class PayslipsController < ApplicationController
  before_action :set_payslip, only: [:show, :edit, :update, :destroy, :download]

  def index
    @payslips = policy_scope(Payslip).includes(:employee).order(pay_period_end: :desc)

    @payslips = @payslips.where(employee_id: params[:employee_id]) if params[:employee_id].present?
    @payslips = @payslips.where(status: params[:status])           if params[:status].present?

    if params[:month].present?
      date      = Date.parse("#{params[:month]}-01") rescue Date.current.beginning_of_month
      @payslips = @payslips.where(pay_period_start: date.beginning_of_month..date.end_of_month)
    end

    @employees = policy_scope(Employee).active.order(:last_name)
    @payslips  = @payslips.page(params[:page]).per(20)
  end

  def show
    authorize @payslip
    @salary_components = @payslip.salary_components.order(:component_type, :name)
    @earnings          = @salary_components.where(component_type: :earning)
    @deductions        = @salary_components.where(component_type: :deduction)
  end

  def new
    @payslip    = Payslip.new
    @payslip.employee_id = params[:employee_id] if params[:employee_id]
    @payslip.pay_period_start = Date.current.beginning_of_month
    @payslip.pay_period_end   = Date.current.end_of_month
    authorize @payslip
    @employees  = policy_scope(Employee).active.order(:last_name)
  end

  def create
    @payslip = Payslip.new(payslip_params)
    @payslip.organization = Current.organization
    authorize @payslip

    if @payslip.save
      redirect_to @payslip, notice: "Payslip generated successfully."
    else
      @employees = policy_scope(Employee).active.order(:last_name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @payslip
    @employees = policy_scope(Employee).active.order(:last_name)
  end

  def update
    authorize @payslip

    if @payslip.update(payslip_params)
      redirect_to @payslip, notice: "Payslip updated."
    else
      @employees = policy_scope(Employee).active.order(:last_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @payslip

    if @payslip.draft?
      @payslip.destroy
      redirect_to payslips_path, notice: "Payslip deleted."
    else
      redirect_to @payslip, alert: "Only draft payslips can be deleted."
    end
  end

  def download
    authorize @payslip, :show?
    respond_to do |format|
      format.pdf do
        pdf = PayslipPdf.new(@payslip)
        send_data pdf.render,
                  filename: "payslip_#{@payslip.employee.last_name}_#{@payslip.pay_period_end.strftime('%Y%m')}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  private

  def set_payslip
    @payslip = policy_scope(Payslip).find(params[:id])
  end

  def payslip_params
    params.require(:payslip).permit(
      :employee_id, :pay_period_start, :pay_period_end,
      :gross_salary, :net_salary, :status, :payment_date, :payment_method, :notes
    )
  end
end