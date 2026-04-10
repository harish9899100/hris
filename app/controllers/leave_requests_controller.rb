class LeaveRequestsController < ApplicationController
  def index
    @leave_requests = current_user.employee.leave_requests
  end

  def new
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = current_user.employee.leave_requests.new(leave_params)

    if @leave_request.save
      redirect_to leave_requests_path, notice: "Leave applied"
    else
      render :new
    end
  end

  private

  def leave_params
    params.require(:leave_request).permit(:start_date, :end_date, :leave_type, :reason)
  end
end