class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # rubocop:disable Lint/UnusedMethodArgument
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
