class DistrictConfig

  def self.fetch_import_filename(var_name)
    ENV.fetch(var_name) { |name| self.handle_unset_import_filename(name) }
  end

  def self.handle_unset_import_filename(missing_name)
    raise "Unset configuration: #{missing_name}" if Rails.env.production?

    # In `Rails.env.development`, we don't need to set all these variables
    # because most developers won't need to use them.

    # The two main developer use cases that would need these variables set are:
      # (1) test the production nightly import process
      # (2) import production data to test on locally.

    # In `Rails.env.test`, we use fixture .txt files and mocks to simulate imported
    # data, and so these variables don't need to be set.
  end

  # Filenames for nightly remote data import

  FILENAME_FOR_STUDENTS_IMPORT = fetch_import_filename(
    'FILENAME_FOR_STUDENTS_IMPORT'
  )

  FILENAME_FOR_EDUCATORS_IMPORT = fetch_import_filename(
    'FILENAME_FOR_EDUCATORS_IMPORT'
  )

  FILENAME_FOR_BEHAVIOR_IMPORT = fetch_import_filename(
    'FILENAME_FOR_BEHAVIOR_IMPORT'
  )

  FILENAME_FOR_ASSESSMENT_IMPORT = fetch_import_filename(
    'FILENAME_FOR_ASSESSMENT_IMPORT'
  )

  FILENAME_FOR_ATTENDANCE_IMPORT = fetch_import_filename(
    'FILENAME_FOR_ATTENDANCE_IMPORT'
  )

  FILENAME_FOR_STAR_READING_IMPORT = fetch_import_filename(
    'FILENAME_FOR_STAR_READING_IMPORT'
  )

  FILENAME_FOR_STAR_MATH_IMPORT = fetch_import_filename(
    'FILENAME_FOR_STAR_MATH_IMPORT'
  )

  FILENAME_FOR_STUDENT_AVERAGES_IMPORT = fetch_import_filename(
    'FILENAME_FOR_STUDENT_AVERAGES_IMPORT'
  )

  FILENAME_FOR_COURSE_SECTION_IMPORT = fetch_import_filename(
    'FILENAME_FOR_COURSE_SECTION_IMPORT'
  )

  FILENAME_FOR_STUDENTS_SECTION_ASSIGNMENT_IMPORT = fetch_import_filename(
    'FILENAME_FOR_STUDENTS_SECTION_ASSIGNMENT_IMPORT'
  )

  FILENAME_FOR_EDUCATOR_SECTION_ASSIGNMENT_IMPORT = fetch_import_filename(
    'FILENAME_FOR_EDUCATOR_SECTION_ASSIGNMENT_IMPORT'
  )

end
