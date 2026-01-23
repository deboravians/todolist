class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    boards_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
