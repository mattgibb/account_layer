class SessionsController < ApplicationController
  skip_before_action :require_login

  def create
    if admin = Admin.find_by(email: oauth_email)
      @token = build_token admin
      render "create", layout: false
    else
      unauthorized
    end
  end

  protected

  def build_token(admin)
    JWT.encode({email: admin.email, exp: Time.now.to_i + 10.minutes}, ENV['JWT_SECRET'])
  end

  def oauth_email
    request.env['omniauth.auth'][:info][:email]
  end
end
