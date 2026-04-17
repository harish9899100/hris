class LeaveRequestsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_leave_request, only: [:show, :edit, :update, :destroy, :approve, :reject]

  def index
    @leave_requests = policy_scope(LeaveRequest).includes(:employee).order(created_at: :desc)
    @leave_requests = @leave_requests.where(status: params[:status])          if params[:status].present?
    @leave_requests = @leave_requests.where(employee_id: params[:employee_id]) if params[:employee_id].present?
    @leave_requests = @leave_requests.where(leave_type: params[:leave_type])   if params[:leave_type].present?
    @employees      = policy_scope(Employee).active.order(:last_name)
    @pending_count  = policy_scope(LeaveRequest).pending.count
    @leave_requests = @leave_requests.page(params[:page]).per(20)
  end

  def show
    authorize @leave_request
  end

  def new
    @leave_request = LeaveRequest.new
    @leave_request.employee_id = params[:employee_id] || current_employee_id
    authorize @leave_request
    @employees = policy_scope(Employee).active.order(:last_name)
  end

  def create
    @leave_request = LeaveRequest.new(leave_request_params)
    @leave_request.employee = current_employee
    @leave_request.organization = Current.organization || Organization.first
    authorize @leave_request

    if @leave_request.save
      LeaveRequestMailer.submission_notification(@leave_request).deliver_later rescue nil
      redirect_to @leave_request, notice: "Leave request submitted successfully."
    else
      flash.now[:error] = @leave_request.errors.full_messages.join(", ")
      puts @leave_request.errors.full_messages
      @employees = policy_scope(Employee).active.order(:last_name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @leave_request
    @employees = policy_scope(Employee).active.order(:last_name)
  end

  def update
    authorize @leave_request

    if @leave_request.update(leave_request_params)
      redirect_to @leave_request, notice: "Leave request updated."
    else
      @employees = policy_scope(Employee).active.order(:last_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @leave_request

    if @leave_request.pending?
      @leave_request.destroy
      redirect_to leave_requests_path, notice: "Leave request cancelled."
    else
      redirect_to @leave_request, alert: "Only pending requests can be deleted."
    end
  end

  def approve
    authorize @leave_request, :review?

    @leave_request.update!(
      status:      :approved,
      reviewer:    current_user,
      reviewed_at: Time.current,
      reviewer_note: params[:reviewer_note]
    )

    LeaveRequestMailer.status_notification(@leave_request).deliver_later rescue nil
    redirect_to leave_requests_path, notice: "Leave request approved."
  end

  def reject
    authorize @leave_request, :review?

    if params[:reviewer_note].blank?
      redirect_to @leave_request, alert: "Please provide a reason for rejection."
      return
    end

    @leave_request.update!(
      status:        :rejected,
      reviewer:      current_user,
      reviewed_at:   Time.current,
      reviewer_note: params[:reviewer_note]
    )

    LeaveRequestMailer.status_notification(@leave_request).deliver_later rescue nil
    redirect_to leave_requests_path, notice: "Leave request rejected."
  end

  private

  def set_leave_request
    @leave_request = policy_scope(LeaveRequest).find(params[:id])
  end

  def current_employee_id
    current_employee&.id
  end

  def leave_request_params
    params.require(:leave_request).permit(
      :employee_id, :leave_type, :start_date, :end_date, :reason, :status
    )
  end
end