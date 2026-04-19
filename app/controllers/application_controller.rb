class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!, unless: -> {:active_admin_controller? || is_a?(DashboardsController) || is_a?(EmployeesController) }
  before_action :set_current_organization
  after_action :verify_pundit_authorization, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  def pundit_user
    return current_admin_user if current_admin_user.present?
    return current_user if current_user.present?
    return current_employee.user if current_employee.present?

    nil
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def skip_pundit?
    devise_controller? || is_a?(ActiveAdmin::BaseController) || current_admin_user.present?
  end

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def set_current_organization
    if current_admin_user.present?
      Current.organization = nil 
    else
      Current.organization = current_user&.organization || current_employee&.organization
    end
  end

  def verify_pundit_authorization
    return if devise_controller?
    return if active_admin_controller?
    return if current_admin_user.present?  

    if controller_name == "employees" && action_name == "index" && @dashboard
      verify_authorized
    elsif action_name == "index"
      verify_policy_scoped
    else
      #verify_authorized
    end
  end
end
