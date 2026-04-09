class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_current_organization

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized
  rescue_from ActiveAdmin::AccessDenied, with: :handle_not_authorized
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  private
  def set_current_organization
    Current.organization = Organization.first
  end

  def set_current_organization
    Current.organization = Organization.first
  end

  def handle_not_authorized(exception)
    flash[:alert] = exception.message.presence || "You are not authorized to perform this action."

    if current_admin_user.present?
      redirect_to destroy_admin_user_session_path, allow_other_host: false
    else
      redirect_to root_path
    end
  end

  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_back(fallback_location: admin_root_path)
  # end
end
