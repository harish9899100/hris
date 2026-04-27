class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!, unless: :admin_namespace?
  before_action :set_current_organization
  after_action :verify_pundit_authorization, unless: :skip_pundit?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  helper_method :current_employee

  private

  def admin_namespace?
    params[:controller].start_with?("admin/") ||
      params[:controller].start_with?("active_admin/")
  end

  def current_employee
    @current_employee ||= current_user&.employee
  end

  def ensure_employee!
    unless current_employee.present?
      redirect_to root_path, alert: "Employee profile not found."
    end
  end

  def pundit_user
    current_user.presence
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back fallback_location: root_path
  end

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def skip_pundit?
    devise_controller? ||
      active_admin_controller? ||
      self.class.name.start_with?("ActiveAdmin::Devise::") ||
      current_admin_user.present?
  end

  def set_current_organization
    if current_admin_user.present?
      Current.organization = nil
    else
      Current.organization = current_user&.organization
    end
  end

  def verify_pundit_authorization
    return if skip_pundit?

    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end
end