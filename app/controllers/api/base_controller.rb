class API::BaseController < ActionController::Base
  abstract!

  before_action :authenticate, :audit_ip_logging

  private

    def audit_ip_logging
      # TODO: log IP address
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        ENV["API_TOKEN"] == token
      end
    end
end
