# frozen_string_literal:true

class SessionsController < ApplicationController
  def new
    redirect_to '/auth/google_oauth2'
  end

  def create
    developer_info = request.env['omniauth.auth']

    developer = Developer.find_or_create_by!(email: developer_info['info']['email'])
    session[:developer_id] = developer.id
    redirect_to root_path, notice: "Welcome #{developer_info['info']['name']}!"
  end

  def destroy
    session[:developer_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
