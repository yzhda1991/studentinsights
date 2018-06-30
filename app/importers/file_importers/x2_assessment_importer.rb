class X2AssessmentImporter

  def initialize(options:)
    @school_scope = options.fetch(:school_scope)
    @log = options.fetch(:log)
    @ignore_old = options.fetch(:ignore_old, false)
    @time_now = options.fetch(:time_now, Time.now)

    @student_ids_map = nil # built lazily
  end

  def import
    return unless remote_file_name

    log('Downloading...')
    streaming_csv = download_csv

    log('Starting loop...')
    @skipped_old_rows_count = 0
    @skipped_because_of_test_type = 0
    @invalid_rows_count = 0
    @updated_rows_count = 0
    @created_rows_count = 0
    @encountered_test_names_count_map = {}
    streaming_csv.each_with_index do |row, index|
      import_row(row) if filter.include?(row)
      log("processed #{index} rows.") if index % 10000 == 0
    end

    log('Done loop.')
    log("@skipped_old_rows_count: #{@skipped_old_rows_count}")
    log("@skipped_because_of_test_type: #{@skipped_because_of_test_type}")
    log("@encountered_test_names_count_map: #{@encountered_test_names_count_map.as_json}")
    log("@created_rows_count: #{@created_rows_count}")
    log("@updated_rows_count: #{@updated_rows_count}")
    log("@invalid_rows_count: #{@invalid_rows_count}")
  end

  def download_csv
    CsvDownloader.new(
      log: @log,
      remote_file_name:
      remote_file_name,
      client: client,
      transformer: data_transformer
    ).get_data
  end

  def client
    SftpClient.for_x2
  end

  def remote_file_name
    LoadDistrictConfig.new.remote_filenames.fetch('FILENAME_FOR_ASSESSMENT_IMPORT', nil)
  end

  def data_transformer
    StreamingCsvTransformer.new(@log)
  end

  def filter
    SchoolFilter.new(@school_scope)
  end

  def import_row(row)
    # Expects the following headers:
    #
    #   :state_id, :local_id, :school_local_id, :assessment_date,
    #   :assessment_scale_score, :assessment_performance_level, :assessment_growth,
    #   :assessment_name, :assessment_subject, :assessment_test

    # Ignore older assessments, optionally
    if @ignore_old && is_old?(row)
      @skipped_old_rows_count = @skipped_old_rows_count + 1
      return
    end

    # Some kind of cleanup
    row[:assessment_growth] = nil if !/\D/.match(row[:assessment_growth]).nil?

    # Find out how to interpret the record based on `assessment_test`
    # and ignore unexpected ones
    tick_test_type_counter(row[:assessment_test])
    row_class = case row[:assessment_test]
      when 'MCAS' then McasRow
      when 'ACCESS', 'WIDA-ACCESS' then AccessRow
      when 'DIBELS' then DibelsRow
      else nil
    end
    if row_class.nil?
      @skipped_because_of_test_type = @skipped_because_of_test_type + 1
      return
    end

    # Try to build a student_assessment record in memory (without saving)
    student_id = lookup_student_id(row[:local_id])
    maybe_student_assessment = row_class.new(row, student_id, assessments_array).build
    if maybe_student_assessment.nil?
      @invalid_rows_count = @invalid_rows_count + 1
      return
    end

    # Check if anything changed
    if !maybe_student_assessment.changed?
      @unchanged_rows_count = @unchanged_rows_count + 1
      return
    end

    # Save, tracking if it's an update or create
    if maybe_student_assessment.persisted?
      @updated_rows_count = @updated_rows_count + 1
    else
      @created_rows_count = @created_rows_count + 1
    end
    maybe_student_assessment.save!
  end

  def is_old?(row)
    row[:assessment_date] < @time_now - 365.days
  end

  # Prevent repeated queries to this table, which is only ~10-100 records
  def assessments_array
    @assessments_array ||= Assessment.all.to_a
  end

  # For logging
  def tick_test_type_counter(assessment_test)
    if !@encountered_test_names_count_map.has_key?(assessment_test)
      @encountered_test_names_count_map[assessment_test] = 0
    end
    @encountered_test_names_count_map[assessment_test] = @encountered_test_names_count_map[assessment_test] + 1
  end

  # Lookup in memory, instead of querying db for every row
  def lookup_student_id(local_id)
    reset_student_ids_map! if @student_ids_map.nil?
    if !@student_ids_map.has_key?(local_id)
      raise "Could not find student with local_id: #{local_id}"
    end
    @student_ids_map[local_id]
  end

  # Build map all at once, as a performance optimization
  def reset_student_ids_map!
    @student_ids_map = {}
    Student.pluck(:id, :local_id).each do |id, local_id|
      @student_ids_map[local_id] = id
    end
    log("reset_student_ids_map! built map with #{@student_ids_map.keys.size} local_id keys")
  end

  def log(msg)
    text = if msg.class == String then msg else JSON.pretty_generate(msg) end
    @log.puts "X2AssessmentImporter: #{text}"
  end
end
