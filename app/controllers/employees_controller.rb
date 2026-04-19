class EmployeesController < ApplicationController
    
  before_action :authenticate_employee!

  def index
  if current_user&.super_admin? || current_user&.hr_manager?
    @employees = policy_scope(Employee).includes(:department, :position, :user).order(:last_name, :first_name)
    @employees = @employees.where(department_id: params[:department_id]) if params[:department_id].present?
    @employees = @employees.where(employment_status: params[:employment_status]) if params[:employment_status].present?
    @employees = @employees.search(params[:q]) if params[:q].present?
    @departments = policy_scope(Department).order(:name)
    @employees   = @employees.page(params[:page]).per(15)
    @dashboard = false
  else
    @employee = current_user&.employee || current_employee
    return redirect_to root_path, alert: "Employee not found" unless @employee
    authorize @employee, :show?
    @today_record = @employee.attendance_records.find_by(date: Date.current)
    @recent_records = @employee.attendance_records.order(date: :desc).limit(7)
    @pending_leaves = @employee.leave_requests.where(status: :pending)
    @upcoming_leaves = @employee.leave_requests.where(status: :approved).where("start_date >= ?", Date.current)
    @latest_payslip = @employee.payslips.order(created_at: :desc).first
    @month_stats = calculate_month_stats(@employee)
    @dashboard = true
  end
end

  def show
    @employee = Employee.find(params[:id])
    @recent_attendance = @employee.attendance_records.order(date: :desc).limit(10)
    @leave_requests    = @employee.leave_requests.order(created_at: :desc).limit(5)
    @recent_payslips   = @employee.payslips.limit(3)
  end

  def new
    @employee    = Employee.new
    authorize @employee
    @departments = policy_scope(Department).order(:name)
    @positions   = policy_scope(Position).order(:title)
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.organization = Current.organization
    authorize @employee unless current_admin_user.present?

    if @employee.save
      redirect_to @employee, notice: "Employee #{@employee.full_name} was successfully created."
    else
      @departments = policy_scope(Department).order(:name)
      @positions   = policy_scope(Position).order(:title)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @employee
    @departments = policy_scope(Department).order(:name)
    @positions   = policy_scope(Position).order(:title)
  end

  def update
    authorize @employee

    if @employee.update(employee_params)
      redirect_to @employee, notice: "Employee updated successfully."
    else
      @departments = policy_scope(Department).order(:name)
      @positions   = policy_scope(Position).order(:title)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @employee
    @employee.destroy
    redirect_to employees_path, notice: "Employee removed."
  end

  def terminate
    authorize @employee, :update?
    @employee.update!(employment_status: :terminated, termination_date: Date.current)
    redirect_to @employee, notice: "Employee #{@employee.full_name} has been terminated."
  end

  def activate
    authorize @employee, :update?
    @employee.update!(employment_status: :active, termination_date: nil)
    redirect_to @employee, notice: "Employee #{@employee.full_name} has been reactivated."
  end

  private

  def calculate_month_stats(employee)
    records = employee.attendance_records.where(date: Date.current.beginning_of_month..Date.current)

    {
      present: records.where(status: :present).count,
      absent: records.where(status: :absent).count,
      on_leave: records.where(status: :on_leave).count,
      working_days: records.count
    }
  end

  def set_employee
    @employee = policy_scope(Employee).find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :first_name, :last_name, :email, :phone, :date_of_birth, :hire_date, :termination_date, :employment_status, :job_type, :department_id, :position_id, :address, :emergency_contact_name, :emergency_contact_phone, :salary_basis, :base_salary, :avatar
    )
  end
end
