class SitemapController < ApplicationController
  def show
    @posts = Post.published_and_ordered
    @channels = Channel.with_entries
    @developers = Developer.with_entries
    respond_to do |format|
      format.xml
    end
  end
end
