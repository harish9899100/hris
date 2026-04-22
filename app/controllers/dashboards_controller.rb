class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee!
  skip_after_action :verify_pundit_authorization

  def index
    @employee = current_employee
    @attendance = @employee.today_attendance
    @recent_attendance = AttendanceRecord.where(employee_id: @employee.id).recent.limit(7)
    @pending_leaves = LeaveRequest.where(employee_id: @employee.id, status: "pending").recent.limit(3)
    @recent_leaves = LeaveRequest.where(employee_id: @employee.id).recent.limit(5)
    @leave_balance = @employee.leave_balance
    @monthly_records = AttendanceRecord.for_month(Date.current.year, Date.current.month).where(employee_id: @employee.id)
    @present_days = @monthly_records.where(status: "present").count
    @absent_days  = @monthly_records.where(status: "absent").count
    @late_days    = @monthly_records.where(status: "late").count
  end
end