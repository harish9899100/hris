class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @employees_count = Employee.count
    @present_today   = AttendanceRecord.where(date: Date.today, status: :present).count
    @pending_leaves  = LeaveRequest.pending.count
    @my_attendance   = current_user.employee&.attendance_records&.order(date: :desc)&.limit(5) || []
  end
end