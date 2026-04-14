class DashboardsController < ApplicationController
  skip_after_action :verify_pundit_authorization
  def index

    @stats = {
      total_employees: Employee.active.count,
      on_leave_today:  Employee.on_leave.count,
      pending_leaves:  LeaveRequest.pending.count,
      present_today: AttendanceRecord.where(date: Date.today).present.count
    }
    @my_attendance = current_user.employee&.attendance_records&.order(date: :desc)&.limit(5) || []
  end
end