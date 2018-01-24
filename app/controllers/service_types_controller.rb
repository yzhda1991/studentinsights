class ServiceTypesController < ApplicationController
  # Used to supply valid service type names to the service upload page.

  # Authentication by default inherited from ApplicationController.

  before_action :authorize_for_districtwide_access_admin, only: [:is_service_working]

  def authorize_for_districtwide_access_admin
    unless current_educator.admin? && current_educator.districtwide_access?
      render json: { error: "You don't have the correct authorization." }
    end
  end

  def index
    render json: ServiceType.pluck(:name).sort
  end

  def is_service_working
    attendance_officer = ServiceType.find(502)
    student_ids = attendance_officer.services.map(&:student_ids)

    student_names_and_chart_data = student_ids.map |id|
      student = Student.find(id)

      {
        name: "#{student.first_name} #{student.last_name}",
        chart_data: StudentProfileChart.new(student).chart_data
      }
    end
  end

end
