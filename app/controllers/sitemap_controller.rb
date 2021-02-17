class SitemapController < ApplicationController
  def show
    @posts = Post.published_and_ordered
    respond_to do |format|
      format.xml
    end
  end
end
