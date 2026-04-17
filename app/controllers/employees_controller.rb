class EmployeesController < ApplicationController
    
  before_action :authenticate_employee!


  
  def index
    @employees = policy_scope(Employee).includes(:department, :position, :user).order(:last_name, :first_name)
     
    @employees = @employees.where(department_id: params[:department_id]) if params[:department_id].present?
    @employees = @employees.where(employment_status: params[:employment_status]) if params[:employment_status].present?
    @employees = @employees.search(params[:q])                           if params[:q].present?

    @departments = policy_scope(Department).order(:name)
    @employees   = @employees.page(params[:page]).per(15)
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

  def set_employee
    @employee = policy_scope(Employee).find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :first_name, :last_name, :email, :phone, :date_of_birth, :hire_date, :termination_date, :employment_status, :job_type, :department_id, :position_id, :address, :emergency_contact_name, :emergency_contact_phone, :salary_basis, :base_salary, :avatar
    )
  end
end
