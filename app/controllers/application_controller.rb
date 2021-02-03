# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cache_header

  helper_method :editable?

  private

  def editable?(post)
    current_developer && (current_developer == post.developer || current_developer.admin?)
  end

  def require_developer
    redirect_to root_path unless current_developer
  end

  def set_cache_header
    headers['Cache-Control'] = 'no-cache, no-store'
  end
end
