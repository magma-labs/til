# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cache_header

  helper_method :editable?, :likeable?, :logged_in?, :current_developer

  private

  def logged_in?
    current_developer != nil
  end

  def current_developer
    if session[:developer_id]
      @current_developer ||= User.find(session[:developer_id])
    else
      @current_developer = nil
    end
  end

  def editable?(post)
    current_developer && (current_developer == post.developer || current_developer.admin?)
  end

  def likeable?(post)
    current_developer && (current_developer != post.developer)
  end

  def require_developer
    redirect_to root_path unless current_developer
  end

  def set_cache_header
    headers['Cache-Control'] = 'no-cache, no-store'
  end
end
