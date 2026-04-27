class AttendanceRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee!

  def index
    @employee = current_employee
    @year  = params[:year]&.to_i || Date.current.year
    @month = params[:month]&.to_i || Date.current.month
    @records = policy_scope(AttendanceRecord).for_month(@year, @month).order(:date)
    @present_count  = @records.where(status: "present").count
    @absent_count   = @records.where(status: "absent").count
    @late_count     = @records.where(status: "late").count
    @half_day_count = @records.where(status: "half_day").count
    @records_by_date = @records.index_by(&:date)
  end

  def check_in
    authorize AttendanceRecord, :check_in?

    employee = current_employee
    AttendanceRecord.check_in_today!(employee)

    redirect_to dashboards_path, notice: "Checked in at #{Time.current.strftime('%I:%M %p')}"
  rescue RuntimeError => e
    redirect_to dashboards_path, alert: e.message
  end

  def check_out
    authorize AttendanceRecord, :check_out?

    employee = current_employee
    AttendanceRecord.check_out_today!(employee)

    redirect_to dashboards_path, notice: "Checked out at #{Time.current.strftime('%I:%M %p')}"
  rescue RuntimeError => e
    redirect_to dashboards_path, alert: e.message
  end
end