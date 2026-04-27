class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee!
  before_action :set_employee, only: [:show, :edit, :update]

  def index
    @employee = current.employee
    redirect_to root_path, alert: "Employee profile missing" unless @employee
  end

  def show
    authorize @employee
    @recent_attendance = @employee.attendance_records.order(date: :desc).limit(10)
    @recent_leaves = @employee.leave_requests.order(created_at: :desc).limit(5)
    @latest_payslip = @employee.payslips.order(created_at: :desc).first
  end

  def edit
    authorize @employee
  end


  def update
    authorize @employee

    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_employee
    @employee = current_employee
  end

  def employee_params
    params.require(:employee).permit(
      :phone,
      :address,
      :date_of_birth,
      :emergency_contact_name,
      :emergency_contact_phone,
      :avatar
    )
  end
end