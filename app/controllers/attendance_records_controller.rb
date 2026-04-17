class AttendanceRecordsController < ApplicationController
  before_action :authenticate_employee!
  def index
    @attendance_records = current_user.employee.attendance_records.order(date: :desc)
  end

  def create
    record = current_user.employee.attendance_records.find_or_initialize_by(date: Date.today)

    if record.check_in.nil?
      record.check_in = Time.current
      record.status = :present
    else
      record.check_out = Time.current
    end

    record.save!
    redirect_to attendance_records_path, notice: "Attendance updated"
  end
end