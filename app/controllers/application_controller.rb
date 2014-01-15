class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  alias_method :devise_current_user, :current_user
  def current_user
    return if devise_current_user.blank?
    devise_current_user.profile || raise("There is no associated user for #{devise_current_user}!")
  end

private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || root_path
  end
end
