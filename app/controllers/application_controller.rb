class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate
    redirect_to root_path unless current_user || controller_name == 'sessions'
  end

  def cookies_counter
    cookies[:views] = (cookies[:views].present? && current_user) ? (cookies[:views].to_i + 1) : 1
  end

  helper_method :current_user, :authenticate, :cookies_counter
end
