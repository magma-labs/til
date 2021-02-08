# frozen_string_literal:true

class SessionsController < ApplicationController
  def new
    redirect_to '/auth/google_oauth2'
  end

  def create
    developer_info = request.env['omniauth.auth']

    developer = Developer.find_or_create_by!(email: developer_info['info']['email']) do |new_developer|
      new_developer.fullname = developer_info['info']['name']
    end
    reset_session
    session[:developer_email] = developer.email
    redirect_to root_path, notice: "Welcome #{developer_info['info']['name']}!"
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'Signed out!'
  end

  def failure
    redirect_to root_url, alert: "Authentication error: #{params[:message].humanize}"
  end
end
