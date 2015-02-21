class API::BaseController < ActionController::Base
  abstract!

  before_action :authenticate, :audit_ip_logging

  private

    def audit_ip_logging
      # TODO: log IP address
    end

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token, options|
        ENV["API_TOKEN"] == token
      end
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'

      render json: "Do one.", status: 401
    end
end
