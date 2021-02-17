# frozen_string_literal:true

class ClicksController < ApplicationController
  def create
    ad.increment!(:clicks)
    redirect_to ad.link_url
  end

  private

  def ad
    @ad ||= Ad.find(params[:id])
  end
end
