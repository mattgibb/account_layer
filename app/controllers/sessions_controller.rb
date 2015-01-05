class SessionsController < ApplicationController
  skip_before_action :require_login

  def create
    admin = Admin.find_by email: oauth_email

    if admin
      session[:admin_email] = admin.email
    else
      flash[:alert] = "Sorry, you're not allowed in here"
    end

    redirect_to '/'
  end

  def destroy
    session[:admin_email] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  protected

  def oauth_email
    request.env['omniauth.auth'][:info][:email]
  end
end
