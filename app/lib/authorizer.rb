# This class defines authorization rules.
# If you want student data, ask through this class.
# Ideally, start with using `authorized_only`.
# Drop down to calling individual methods if you need to.
#
# This class should be fully tested, and all changes should be reviewed.
# 
# Controller usage:
#   student = authorized_only { Student.find(params[:id]) }
#   homeroom = authorized_only { Homeroom.(params[:id]) }
#   students = authorized_only { homeroom.students } 
#
# Standalone usage:
#   authorizer = Authorizer.new(educator)
#   student = authorizer.authorized_only { Student.find(params[:id]) }
#   homeroom = authorizer.authorized_only { Homeroom.(params[:id]) }
#   students = authorizer.authorized_only { homeroom.students } 
#
# Instead of:
#   Homeroom.find(id).students # no authorization check
#   Section.find(id).students # no authorization check
#   current_educator.homeroom.students # doesn't consider other roles
#   current_educator.school.students # doesn't consider other roles
#
class Authorizer
  def initialize(educator)
    @educator = educator
    @authorized_only = AuthorizedOnly.new(self)
  end

  # Usage:
  #  student = authorized_only { Student.find(params[:id]) }
  def authorized_only(&block)
    @authorized_only.dispatch(&block)
  end

  # This method is the source of truth for whether an educator is authorized to view information about a particular
  # student.
  def is_authorized_for_student?(student)
    return true if @educator.districtwide_access?

    return false if @educator.restricted_to_sped_students && !(student.program_assigned.in? ['Sp Ed', 'SEIP'])
    return false if @educator.restricted_to_english_language_learners && student.limited_english_proficiency == 'Fluent'
    return false if @educator.school_id.present? && student.school_id.present? && @educator.school_id != student.school_id

    return true if @educator.schoolwide_access? || @educator.admin? # Schoolwide admin
    return true if @educator.has_access_to_grade_levels? && student.grade.in?(@educator.grade_level_access) # Grade level access
    return true if student.in?(@educator.students) # Homeroom level access
    return true if student.in?(@educator.section_students) # Section level access
    false
  end
end