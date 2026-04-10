class PayslipsController < ApplicationController
  def index
    @payslips = current_user.employee.payslips
  end

  def show
    @payslip = Payslip.find(params[:id])
  end
end