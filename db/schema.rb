# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_27_123632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", id: :serial, force: :cascade do |t|
    t.date "occurred_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id", null: false
    t.boolean "dismissed"
    t.boolean "excused"
    t.string "reason"
    t.string "comment"
    t.index ["student_id", "occurred_at"], name: "index_absences_on_student_id_and_occurred_at", unique: true
    t.index ["student_id"], name: "index_absences_on_student_id"
  end

  create_table "assessments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "family"
    t.string "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_list_snapshots", force: :cascade do |t|
    t.integer "class_list_id"
    t.json "students_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_lists", force: :cascade do |t|
    t.string "workspace_id"
    t.integer "created_by_teacher_educator_id"
    t.integer "school_id"
    t.string "grade_level_next_year"
    t.json "json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "submitted", default: false
    t.json "principal_revisions_json"
    t.integer "revised_by_principal_educator_id"
    t.index ["workspace_id", "created_at"], name: "index_class_lists_on_workspace_id_and_created_at", order: { created_at: :desc }
  end

  create_table "counselor_name_mappings", force: :cascade do |t|
    t.text "counselor_field_text"
    t.integer "educator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "course_number"
    t.string "course_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "school_id", null: false
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "dibels_results", force: :cascade do |t|
    t.string "benchmark", null: false
    t.string "subtest_results"
    t.bigint "student_id", null: false
    t.datetime "date_taken", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_dibels_results_on_student_id"
  end

  create_table "discipline_incidents", id: :serial, force: :cascade do |t|
    t.string "incident_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "incident_location"
    t.text "incident_description"
    t.datetime "occurred_at", null: false
    t.boolean "has_exact_time"
    t.integer "student_id", null: false
    t.index ["student_id"], name: "index_discipline_incidents_on_student_id"
  end

  create_table "educator_labels", force: :cascade do |t|
    t.integer "educator_id"
    t.text "label_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educator_multifactor_configs", force: :cascade do |t|
    t.integer "educator_id", null: false
    t.string "sms_number"
    t.datetime "last_verification_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rotp_secret", null: false
    t.index ["educator_id"], name: "index_educator_multifactor_configs_on_educator_id", unique: true
    t.index ["rotp_secret"], name: "index_educator_multifactor_configs_on_rotp_secret", unique: true
    t.index ["sms_number"], name: "index_educator_multifactor_configs_on_sms_number", unique: true
  end

  create_table "educator_section_assignments", force: :cascade do |t|
    t.integer "section_id", null: false
    t.integer "educator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["educator_id"], name: "index_educator_section_assignments_on_educator_id"
    t.index ["section_id"], name: "index_educator_section_assignments_on_section_id"
  end

  create_table "educators", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.string "phone"
    t.string "full_name"
    t.string "state_id"
    t.string "local_id"
    t.string "staff_type"
    t.integer "school_id"
    t.boolean "schoolwide_access", default: false, null: false
    t.string "grade_level_access", default: [], array: true
    t.boolean "restricted_to_sped_students", default: false, null: false
    t.boolean "restricted_to_english_language_learners", default: false, null: false
    t.boolean "can_view_restricted_notes", default: false, null: false
    t.boolean "districtwide_access", default: false, null: false
    t.boolean "can_set_districtwide_access", default: false, null: false
    t.text "student_searchbar_json"
    t.text "login_name", null: false
    t.index ["email"], name: "index_educators_on_email", unique: true
    t.index ["grade_level_access"], name: "index_educators_on_grade_level_access", using: :gin
    t.index ["login_name"], name: "index_educators_on_login_name", unique: true
  end

  create_table "event_note_attachments", id: :serial, force: :cascade do |t|
    t.string "url", null: false
    t.integer "event_note_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_note_revisions", id: :serial, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "educator_id", null: false
    t.integer "event_note_type_id", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_note_id", null: false
    t.integer "version", null: false
  end

  create_table "event_note_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_notes", id: :serial, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "educator_id", null: false
    t.integer "event_note_type_id", null: false
    t.text "text", null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_restricted", default: false, null: false
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "historical_grades", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "section_id"
    t.text "section_number"
    t.text "course_number"
    t.text "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_historical_grades_on_section_id"
    t.index ["student_id"], name: "index_historical_grades_on_student_id"
  end

  create_table "historical_levels_snapshots", force: :cascade do |t|
    t.datetime "time_now"
    t.json "student_ids"
    t.json "students_with_levels_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "homerooms", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "students_count", default: 0, null: false
    t.integer "educator_id"
    t.string "slug", null: false
    t.string "grade"
    t.integer "school_id", null: false
    t.index ["educator_id"], name: "index_homerooms_on_educator_id"
    t.index ["school_id", "name"], name: "index_homerooms_on_school_id_and_name", unique: true
    t.index ["slug"], name: "index_homerooms_on_slug", unique: true
  end

  create_table "homework_help_sessions", force: :cascade do |t|
    t.integer "student_id"
    t.datetime "form_timestamp"
    t.json "course_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recorded_by_educator_id", null: false
  end

  create_table "house_educator_mappings", force: :cascade do |t|
    t.text "house_field_text", null: false
    t.integer "educator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "iep_documents", id: :serial, force: :cascade do |t|
    t.string "file_name", null: false
    t.integer "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_digest", null: false
    t.integer "file_size", null: false
    t.string "s3_filename", null: false
    t.index ["student_id"], name: "index_iep_documents_on_student_id"
  end

  create_table "import_records", id: :serial, force: :cascade do |t|
    t.datetime "time_started"
    t.datetime "time_ended"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "importer_timing_json"
    t.text "task_options_json"
    t.text "log", default: ""
  end

  create_table "intervention_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interventions", id: :serial, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "intervention_type_id", null: false
    t.text "comment"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "educator_id", null: false
    t.integer "number_of_hours"
    t.text "goal"
    t.string "custom_intervention_name"
  end

  create_table "login_activities", force: :cascade do |t|
    t.text "scope"
    t.text "strategy"
    t.string "identity"
    t.boolean "success"
    t.text "failure_reason"
    t.string "user_type"
    t.bigint "user_id"
    t.text "context"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "city"
    t.text "region"
    t.text "country"
    t.datetime "created_at"
    t.index ["identity"], name: "index_login_activities_on_identity"
    t.index ["ip"], name: "index_login_activities_on_ip"
    t.index ["user_type", "user_id"], name: "index_login_activities_on_user_type_and_user_id"
  end

  create_table "masquerading_logs", force: :cascade do |t|
    t.integer "educator_id"
    t.integer "masquerading_as_educator_id"
    t.text "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "precomputed_query_docs", id: :serial, force: :cascade do |t|
    t.text "key"
    t.text "json"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "authorized_students_digest"
    t.index ["key"], name: "index_precomputed_query_docs_on_key"
  end

  create_table "schools", id: :serial, force: :cascade do |t|
    t.string "school_type", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "local_id", null: false
    t.string "slug", null: false
    t.index ["local_id"], name: "index_schools_on_local_id"
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.string "section_number", null: false
    t.string "term_local_id", null: false
    t.string "schedule"
    t.string "room_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "course_id", null: false
  end

  create_table "service_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "summer_program", default: false
  end

  create_table "service_uploads", id: :serial, force: :cascade do |t|
    t.integer "uploaded_by_educator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_name"
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "recorded_by_educator_id", null: false
    t.integer "service_type_id", null: false
    t.datetime "recorded_at", null: false
    t.datetime "date_started", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provided_by_educator_name"
    t.integer "service_upload_id"
    t.datetime "estimated_end_date"
    t.datetime "discontinued_at"
    t.integer "discontinued_by_educator_id"
  end

  create_table "star_math_results", force: :cascade do |t|
    t.integer "percentile_rank", null: false
    t.string "grade_equivalent", null: false
    t.integer "total_time", null: false
    t.bigint "student_id", null: false
    t.datetime "date_taken", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_star_math_results_on_student_id"
  end

  create_table "star_reading_results", force: :cascade do |t|
    t.integer "percentile_rank", null: false
    t.integer "total_time", null: false
    t.string "grade_equivalent", null: false
    t.decimal "instructional_reading_level", null: false
    t.bigint "student_id", null: false
    t.datetime "date_taken", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_star_reading_results_on_student_id"
  end

  create_table "student_assessments", id: :serial, force: :cascade do |t|
    t.integer "scale_score"
    t.integer "growth_percentile"
    t.string "performance_level"
    t.datetime "date_taken"
    t.integer "student_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "percentile_rank"
    t.decimal "instructional_reading_level"
    t.integer "assessment_id", null: false
    t.string "grade_equivalent"
    t.index ["student_id"], name: "index_student_assessments_on_student_id"
  end

  create_table "student_photos", force: :cascade do |t|
    t.bigint "student_id"
    t.string "file_digest", null: false
    t.integer "file_size", null: false
    t.string "s3_filename", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_student_photos_on_student_id"
  end

  create_table "student_section_assignments", force: :cascade do |t|
    t.integer "section_id"
    t.integer "student_id"
    t.decimal "grade_numeric"
    t.string "grade_letter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_student_section_assignments_on_section_id"
    t.index ["student_id"], name: "index_student_section_assignments_on_student_id"
  end

  create_table "student_voice_completed_surveys", force: :cascade do |t|
    t.integer "student_voice_survey_upload_id", null: false
    t.integer "student_id", null: false
    t.datetime "form_timestamp", null: false
    t.text "first_name", null: false
    t.text "student_lasid", null: false
    t.text "proud", null: false
    t.text "best_qualities", null: false
    t.text "activities_and_interests", null: false
    t.text "nervous_or_stressed", null: false
    t.text "learn_best", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_voice_survey_uploads", force: :cascade do |t|
    t.text "file_name", null: false
    t.integer "file_size", default: 0, null: false
    t.text "file_digest", null: false
    t.integer "uploaded_by_educator_id", null: false
    t.boolean "completed", default: false, null: false
    t.json "stats", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.string "grade"
    t.boolean "hispanic_latino"
    t.string "race"
    t.string "free_reduced_lunch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "homeroom_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "state_id"
    t.string "home_language"
    t.integer "school_id", null: false
    t.string "student_address"
    t.datetime "registration_date"
    t.string "local_id", null: false
    t.string "program_assigned"
    t.string "sped_placement"
    t.string "disability"
    t.string "sped_level_of_need"
    t.string "plan_504"
    t.string "limited_english_proficiency"
    t.integer "most_recent_mcas_math_growth"
    t.integer "most_recent_mcas_ela_growth"
    t.string "most_recent_mcas_math_performance"
    t.string "most_recent_mcas_ela_performance"
    t.integer "most_recent_mcas_math_scaled"
    t.integer "most_recent_mcas_ela_scaled"
    t.integer "most_recent_star_reading_percentile"
    t.integer "most_recent_star_math_percentile"
    t.string "enrollment_status"
    t.datetime "date_of_birth"
    t.string "gender"
    t.string "primary_phone"
    t.string "primary_email"
    t.text "house"
    t.text "counselor"
    t.text "sped_liaison"
    t.boolean "missing_from_last_export", default: false, null: false
    t.date "ell_entry_date"
    t.date "ell_transition_date"
    t.index ["homeroom_id"], name: "index_students_on_homeroom_id"
    t.index ["local_id"], name: "index_students_on_local_id", unique: true
    t.index ["school_id"], name: "index_students_on_school_id"
    t.index ["state_id"], name: "index_students_on_state_id"
  end

  create_table "tardies", id: :serial, force: :cascade do |t|
    t.date "occurred_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id", null: false
    t.boolean "dismissed"
    t.boolean "excused"
    t.string "reason"
    t.string "comment"
    t.index ["student_id", "occurred_at"], name: "index_tardies_on_student_id_and_occurred_at", unique: true
    t.index ["student_id"], name: "index_tardies_on_student_id"
  end

  create_table "team_memberships", force: :cascade do |t|
    t.integer "student_id", null: false
    t.text "activity_text", null: false
    t.text "coach_text", null: false
    t.text "school_year_text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transition_notes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "educator_id"
    t.bigint "student_id"
    t.text "text"
    t.datetime "recorded_at"
    t.boolean "is_restricted", default: false
    t.index ["educator_id"], name: "index_transition_notes_on_educator_id"
    t.index ["student_id"], name: "index_transition_notes_on_student_id"
  end

  add_foreign_key "absences", "students"
  add_foreign_key "class_list_snapshots", "class_lists"
  add_foreign_key "class_lists", "educators", column: "created_by_teacher_educator_id", name: "classrooms_for_created_by_educator_id_fk"
  add_foreign_key "class_lists", "educators", column: "revised_by_principal_educator_id", name: "class_lists_revised_by_principal_educator_id_fk"
  add_foreign_key "class_lists", "schools", name: "classrooms_for_grades_school_id_fk"
  add_foreign_key "counselor_name_mappings", "educators", name: "counselor_name_mappings_educator_id_fk"
  add_foreign_key "courses", "schools", name: "courses_school_id_fk"
  add_foreign_key "dibels_results", "students"
  add_foreign_key "discipline_incidents", "students"
  add_foreign_key "educator_labels", "educators", name: "educator_labels_educator_id_fk"
  add_foreign_key "educator_multifactor_configs", "educators"
  add_foreign_key "educator_section_assignments", "educators"
  add_foreign_key "educator_section_assignments", "sections"
  add_foreign_key "educators", "schools", name: "educators_school_id_fk"
  add_foreign_key "event_note_attachments", "event_notes", name: "event_note_attachments_event_note_id_fk"
  add_foreign_key "event_note_revisions", "educators", name: "event_note_revisions_educator_id_fk"
  add_foreign_key "event_note_revisions", "event_note_types"
  add_foreign_key "event_note_revisions", "event_notes"
  add_foreign_key "event_note_revisions", "event_notes", name: "event_note_revisions_event_note_id_fk"
  add_foreign_key "event_note_revisions", "students", name: "event_note_revisions_student_id_fk"
  add_foreign_key "event_notes", "educators", name: "event_notes_educator_id_fk"
  add_foreign_key "event_notes", "event_note_types"
  add_foreign_key "event_notes", "event_note_types", name: "event_notes_event_note_type_id_fk"
  add_foreign_key "event_notes", "students", name: "event_notes_student_id_fk"
  add_foreign_key "historical_grades", "sections", name: "historical_grades_section_id_fk"
  add_foreign_key "historical_grades", "students", name: "historical_grades_student_id_fk"
  add_foreign_key "homerooms", "educators", name: "homerooms_educator_id_fk"
  add_foreign_key "homerooms", "educators", name: "homerooms_for_educator_id_fk"
  add_foreign_key "homerooms", "schools", name: "homerooms_for_school_id_fk"
  add_foreign_key "homerooms", "schools", name: "homerooms_school_id_fk"
  add_foreign_key "homework_help_sessions", "educators", column: "recorded_by_educator_id", name: "homework_help_sessions_recorded_by_educator_id_fk"
  add_foreign_key "homework_help_sessions", "students", name: "homework_help_sessions_student_id_fk"
  add_foreign_key "house_educator_mappings", "educators", name: "house_educator_mappings_educator_id_fk"
  add_foreign_key "iep_documents", "students", name: "iep_documents_student_id_fk"
  add_foreign_key "interventions", "educators", name: "interventions_educator_id_fk"
  add_foreign_key "interventions", "intervention_types", name: "interventions_intervention_type_id_fk"
  add_foreign_key "interventions", "students", name: "interventions_student_id_fk"
  add_foreign_key "masquerading_logs", "educators"
  add_foreign_key "masquerading_logs", "educators", column: "masquerading_as_educator_id"
  add_foreign_key "sections", "courses", name: "sections_course_id_fk"
  add_foreign_key "service_uploads", "educators", column: "uploaded_by_educator_id", name: "service_uploads_uploaded_by_educator_id_fk"
  add_foreign_key "services", "educators", column: "recorded_by_educator_id", name: "services_recorded_by_educator_id_fk"
  add_foreign_key "services", "service_types", name: "services_service_type_id_fk"
  add_foreign_key "services", "service_uploads", name: "services_service_upload_id_fk"
  add_foreign_key "services", "students", name: "services_student_id_fk"
  add_foreign_key "star_math_results", "students"
  add_foreign_key "star_reading_results", "students"
  add_foreign_key "student_assessments", "assessments", name: "student_assessments_assessment_id_fk"
  add_foreign_key "student_assessments", "students", name: "student_assessments_student_id_fk"
  add_foreign_key "student_photos", "students"
  add_foreign_key "student_section_assignments", "sections"
  add_foreign_key "student_section_assignments", "sections", name: "student_section_assignments_section_id_fk"
  add_foreign_key "student_section_assignments", "students"
  add_foreign_key "student_section_assignments", "students", name: "student_section_assignments_student_id_fk"
  add_foreign_key "student_voice_completed_surveys", "student_voice_survey_uploads", name: "student_voice_completed_surveys_for_student_voice_survey_upload"
  add_foreign_key "student_voice_completed_surveys", "students", name: "student_voice_completed_surveys_for_student_id_fk"
  add_foreign_key "student_voice_survey_uploads", "educators", column: "uploaded_by_educator_id", name: "student_voice_survey_uploads_for_uploaded_by_educator_id_fk"
  add_foreign_key "students", "homerooms", name: "students_homeroom_id_fk"
  add_foreign_key "students", "schools", name: "students_school_id_fk"
  add_foreign_key "tardies", "students"
  add_foreign_key "team_memberships", "students"
  add_foreign_key "transition_notes", "educators"
  add_foreign_key "transition_notes", "students"
end
