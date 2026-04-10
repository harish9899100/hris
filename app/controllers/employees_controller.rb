class EmployeesController < ApplicationController
  def index
    @employee = policy_scope(Employee)
  end
  def show
    @employee = Employee.find(params[:id])
    authorize @employee
  end
end
