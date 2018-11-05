# Used on the console to import data about homework help sessions.
#
# Usage:
# file_text = <<EOD
# ...
# EOD
# educator = Educator.find_by_login_name('...')
# output = HomeworkHelpImporter.new(educator.id).import(file_text);nil
class HomeworkHelpImporter
  def initialize(educator_id, options = {})
    @educator_id = educator_id
    @log = options.fetch(:log, Rails.env.test? ? LogHelper::Redirect.instance.file : STDOUT)
    @matcher = options.fetch(:matcher, ::ImportMatcher.new(strptime_format: ImportMatcher::GOOGLE_FORM_EXPORTED_TO_GOOGLE_SHEETS_TIMESTAMP_FORMAT))
  end

  def import(file_text, options = {})
    # parse
    rows = []
    create_streaming_csv(file_text).each_with_index do |row, index|
      maybe_row = maybe_parse_row(row.to_h, index)
      next if maybe_row.nil?
      rows << maybe_row
      @matcher.count_valid_row
    end
    log "matcher#stats: #{@matcher.stats}"

    # write to database
    homework_help_sessions = nil
    HomeworkHelpSession.transaction do
      HomeworkHelpSession.destroy_all
      homework_help_sessions = rows.map {|row| HomeworkHelpSession.create!(row) }
    end
    homework_help_sessions
  end

  private
  def maybe_parse_row(row, index)
    course_ids = parse_and_match_courses(row)
    if course_ids.size == 0
      @matcher.count_invalid_row
      return nil
    end

    {
      recorded_by_educator_id: @educator_id,
      student_id: @matcher.find_student_id(row['Student Local ID Number']),
      form_timestamp: @matcher.parse_timestamp(row['Timestamp']),
      course_ids: course_ids
    }
  end

  # Read all courses, map to numbers, lookup
  def parse_and_match_courses(row)
    course_names = [
      row['English classes'].try(:split, ','),
      row['ELE Classes'].try(:split, ','),
      row['Science classes'].try(:split, ','),
      row['Social Studies classes'].try(:split, ','),
      row['Math classes'].try(:split, ',')
    ].flatten.compact
    
    course_numbers = course_names.flat_map do |course_name|
      match = course_name.match(/\((\d+)\)/)
      if match.nil? then [] else [match[1]] end
    end
    
    course_numbers.map {|course_number| @matcher.find_course_id(course_number) }.compact
  end


  def create_streaming_csv(file_text)
    csv_transformer = StreamingCsvTransformer.new(@log, {
      csv_options: { header_converters: nil }
    })
    csv_transformer.transform(file_text)
  end

  def log(msg)
    text = if msg.class == String then msg else JSON.pretty_generate(msg) end
    @log.puts "HomeworkHelpImporter: #{text}"
  end
end
