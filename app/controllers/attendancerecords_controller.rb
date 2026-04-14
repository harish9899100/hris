class AttendanceRecordsController < ApplicationController
  before_action :set_attendance_record, only: [:show, :edit, :update, :destroy]

  def index
    @attendance_records = policy_scope(AttendanceRecord)
                            .includes(:employee)
                            .order(date: :desc, clock_in: :desc)

    @attendance_records = apply_filters(@attendance_records)
    @employees          = policy_scope(Employee).active.order(:last_name)
    @attendance_records = @attendance_records.page(params[:page]).per(25)
  end

  def show
    authorize @attendance_record
  end

  def new
    @attendance_record = AttendanceRecord.new(date: Date.current)
    @attendance_record.employee_id = params[:employee_id] if params[:employee_id]
    authorize @attendance_record
    @employees = policy_scope(Employee).active.order(:last_name)
  end

  def create
    @attendance_record = AttendanceRecord.new(attendance_record_params)
    @attendance_record.organization = Current.organization
    authorize @attendance_record

    if @attendance_record.save
      redirect_to attendance_records_path, notice: "Attendance recorded."
    else
      @employees = policy_scope(Employee).active.order(:last_name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @attendance_record
    @employees = policy_scope(Employee).active.order(:last_name)
  end

  def update
    authorize @attendance_record

    if @attendance_record.update(attendance_record_params)
      redirect_to attendance_records_path, notice: "Attendance record updated."
    else
      @employees = policy_scope(Employee).active.order(:last_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @attendance_record
    @attendance_record.destroy
    redirect_to attendance_records_path, notice: "Record deleted."
  end

  def clock_in
    @employee = policy_scope(Employee).find(params[:employee_id])
    authorize @employee, :clock_in?

    record = AttendanceRecord.find_or_initialize_by(
      employee: @employee,
      date:     Date.current,
      organization: Current.organization
    )

    if record.clock_in.present?
      redirect_to attendance_records_path, alert: "Already clocked in today."
    else
      record.clock_in = Time.current
      record.status   = :present
      if record.save
        redirect_to attendance_records_path, notice: "Clocked in at #{record.clock_in.strftime('%H:%M')}."
      else
        redirect_to attendance_records_path, alert: "Clock-in failed: #{record.errors.full_messages.join(', ')}"
      end
    end
  end

  def clock_out
    @attendance_record = AttendanceRecord.find(params[:id])
    authorize @attendance_record, :update?

    if @attendance_record.clock_out.present?
      redirect_to attendance_records_path, alert: "Already clocked out."
    else
      @attendance_record.update!(clock_out: Time.current)
      hours = @attendance_record.hours_worked
      redirect_to attendance_records_path, notice: "Clocked out. #{hours&.round(1)} hours worked today."
    end
  end

  private

  def set_attendance_record
    @attendance_record = policy_scope(AttendanceRecord).find(params[:id])
  end

  def apply_filters(scope)
    scope = scope.where(employee_id: params[:employee_id]) if params[:employee_id].present?
    scope = scope.where(status: params[:status])           if params[:status].present?
    scope = scope.where(date: parse_date_range)            if params[:from_date].present?
    scope
  end

  def parse_date_range
    from = Date.parse(params[:from_date]) rescue Date.current.beginning_of_month
    to   = params[:to_date].present? ? Date.parse(params[:to_date]) : Date.current
    from..to
  end

  def attendance_record_params
    params.require(:attendance_record).permit(
      :employee_id, :date, :clock_in, :clock_out, :status, :notes
    )
  end
end