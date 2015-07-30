module Importer
  include ProgressBar
  # Any class using X2Importer should implement two methods:
  # export_file_name => string pointing to the name of the remote file to parse
  # import_row => function that describes how to handle each row (implemented by handle_row)

  def initialize(options = {})
    # Required arguments
    @client = options[:client]
    @data_transformer = options[:data_transformer]

    # Optional arguments (for scoping import)
    @school = options[:school]
    @recent_only = options[:recent_only]
    @summer_school_local_ids = options[:summer_school_local_ids]    # For importing only summer school students
  end

  # SCOPED IMPORT #

  def connect_transform_import
    file = @client.fetch_file
    data = @data_transformer.transform(file)
    import(data)  # Import an array of hashes
  end

  def import(data)
    # Set up for proress bar
    if Rails.env.development?
      n = 0
      number_of_rows = data.size
    end

    # Import
    data.each do |row|
      row.length.times { row.delete(nil) }
      handle_row(row)
      if Rails.env.development?
        n += 1
        print progress_bar(n, number_of_rows)
      end
    end

    # Exit
    puts if Rails.env.development?
    return data
  end

  def handle_row(row)
    if @school.present?
      import_if_in_school_scope(row)
    elsif @summer_school_local_ids.present?
      import_if_in_summer_school(row)
    else
      import_row row
    end
  end

  def import_if_in_school_scope(row)
    if @school.local_id == row[:school_local_id]
      import_row row
    end
  end

  def import_if_in_summer_school(row)
    if @summer_school_local_ids.include? row[:local_id]
      import_row row
    end
  end
end
