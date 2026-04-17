class DashboardsController < ApplicationController
  skip_after_action :verify_pundit_authorization
  def index
    employees = Employee.all

    @stats = {
      total_employees: employees.active.count,
      on_leave_today: employees.on_leave.count,
      pending_leaves: LeaveRequest.pending.count,
      present_today: AttendanceRecord.where(date: Date.today).count
    }

    @recent_employees = employees.order(created_at: :desc).limit(5)
    @monthly_leave_summary = LeaveRequest.group(:status).count
    @pending_leaves = LeaveRequest.pending.limit(5)
    @today_attendance = AttendanceRecord.where(date: Date.today).limit(10)
    @department_headcount = employees.joins(:department).group("departments.name").count
  end
end