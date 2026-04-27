class LeaveRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee!
  before_action :set_leave_request, only: [:show, :cancel]

  def index
    @employee = current_employee

    @leave_requests = policy_scope(LeaveRequest).recent

    if params[:status].present? &&
       LeaveRequest::STATUSES.include?(params[:status])
      @leave_requests = @leave_requests.where(status: params[:status])
    end

    @leave_balance = @employee.leave_balance
  end

  def show
  end

  def new
    @leave_request = LeaveRequest.new
    authorize @leave_request

    @employee = current_employee
    @leave_balance = @employee.leave_balance
  end

  def create
    @employee = current_employee
    @leave_request = LeaveRequest.new(leave_request_params)

    authorize @leave_request

    @leave_request.employee_id = @employee.id
    @leave_request.organization_id = @employee.organization_id
    @leave_request.status = "pending"

    if @leave_request.save
      redirect_to leave_requests_path, notice: "Leave request submitted. Awaiting approval."
    else
      @leave_balance = @employee.leave_balance
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    if @leave_request.can_cancel?
      @leave_request.update!(status: "cancelled")

      redirect_to leave_requests_path, notice: "Leave request cancelled."
    else
      redirect_to leave_requests_path, alert: "This leave request cannot be cancelled."
    end
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
    authorize @leave_request
  end

  def leave_request_params
    params.require(:leave_request).permit(:leave_type, :start_date, :end_date, :reason)
  end
end