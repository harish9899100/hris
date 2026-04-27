class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  def index
    @positions = policy_scope(Position).includes(:department, :employees).order(:title)

    @positions = @positions.where(department_id: params[:department_id]) if params[:department_id].present?
    @departments = policy_scope(Department).order(:name)
    @positions   = @positions.page(params[:page]).per(20)
  end

  def show
    authorize @position
    @employees = @position.employees.active.includes(:department)
  end

  def new
    @position    = Position.new
    @position.department_id = params[:department_id] if params[:department_id]
    authorize @position
    @departments = policy_scope(Department).order(:name)
  end

  def create
    @position = Position.new(position_params)
    @position.organization = Current.organization
    authorize @position

    if @position.save
      redirect_to @position, notice: "Position created."
    else
      @departments = policy_scope(Department).order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @position
    @departments = policy_scope(Department).order(:name)
  end

  def update
    authorize @position

    if @position.update(position_params)
      redirect_to @position, notice: "Position updated."
    else
      @departments = policy_scope(Department).order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @position

    if @position.employees.active.any?
      redirect_to @position, alert: "Cannot delete a position with active employees."
    else
      @position.destroy
      redirect_to positions_path, notice: "Position removed."
    end
  end

  private

  def set_position
    @position = policy_scope(Position).find(params[:id])
  end

  def position_params
    params.require(:position).permit(:title, :department_id, :description, :min_salary, :max_salary, :level, :is_active)
  end
end