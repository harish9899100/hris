class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  def index
    @departments = policy_scope(Department).includes(:positions, :employees).order(:name)
    @departments = @departments.page(params[:page]).per(20)
  end

  def show
    authorize @department
    @employees  = @department.employees.active.includes(:position).order(:last_name)
    @positions  = @department.positions.order(:title)
  end

  def new
    @department = Department.new
    authorize @department
  end

  def create
    @department = Department.new(department_params)
    @department.organization = Current.organization
    authorize @department

    if @department.save
      redirect_to @department, notice: "Department created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @department
  end

  def update
    authorize @department

    if @department.update(department_params)
      redirect_to @department, notice: "Department updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @department

    if @department.employees.active.any?
      redirect_to @department, alert: "Cannot delete department with active employees."
    else
      @department.destroy
      redirect_to departments_path, notice: "Department removed."
    end
  end

  private

  def set_department
    @department = policy_scope(Department).find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name, :description, :manager_id, :cost_center)
  end
end