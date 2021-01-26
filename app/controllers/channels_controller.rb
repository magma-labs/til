# frozen_string_literal: true

class ChannelsController < ApplicationController
  helper_method :channel, :posts

  private

  def channel
    @channel ||= Channel.find_by!(name: params[:id])
  end

  def posts
    @posts ||= channel.posts.published_and_ordered.includes(:developer)
  end
end
