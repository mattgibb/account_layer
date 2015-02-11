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
    payload = {
      email: admin.email,
      name: admin.name,
      exp: Time.now.to_i + 10.minutes
    }

    JWT.encode payload, ENV['JWT_SECRET']
  end

  def oauth_email
    request.env['omniauth.auth'][:info][:email]
  end
end
