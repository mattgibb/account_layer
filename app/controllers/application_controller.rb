class ApplicationController < ActionController::Base
  class NotAuthenticated < Exception; end
  # switch this on for production
  # force_ssl

  before_action :require_login

  rescue_from NotAuthenticated, with: :unauthorized

  rescue_from JWT::DecodeError,      with: :invalid_token
  rescue_from JWT::ExpiredSignature, with: :expired_token

  helper_method :current_admin

  private

    def unauthorized
      render text: "Do one.", status: 401
    end

    def current_admin
      @current_admin ||= Admin.find_by email: admin_email if admin_email
    end

    def require_login
      raise NotAuthenticated unless current_admin
    end

    def admin_email
      JWT.decode(token, ENV['JWT_SECRET']).first["email"]
    end

    def token
      if auth_header = request.headers["Authorization"]
        auth_header[/Bearer (.*)/, 1]
      end
    end

    def invalid_token
      # TODO: record attempted hack?
      unauthorized
    end

    def expired_token
      render text: "Your JWT expired", status: 401
    end
end
