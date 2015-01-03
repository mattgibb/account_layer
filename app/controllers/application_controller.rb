class ApplicationController < ActionController::Base
  class NotAuthenticated < Exception; end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # switch this on for production
  # force_ssl

  before_action :require_login

  rescue_from NotAuthenticated do
    render "Do one.", status: 401
  end

  helper_method :current_admin

  private

    def current_admin
      @current_admin ||= Admin.find_by email: session[:admin_email] if session[:admin_email]
    end

    def require_login
      raise NotAuthenticated unless current_admin
    end
end
