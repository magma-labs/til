# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update]
  before_action :require_developer, except: %i[index show like unlike]
  before_action :authorize_developer, only: %i[edit update]
  before_action :no_self_like, only: %i[like unlike]

  def preview
    render layout: false
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.developer = current_developer
    if @post.save
      path = process_post
      redirect_to path, notice: "#{display_name(@post)}created"
    else
      render :new
    end
  end

  def index
    @posts = posts_with_developer_and_channel.published_and_ordered.search(params[:q])

    respond_to do |format|
      format.html
      format.json { render json: @posts }
      format.atom
    end
  end

  def show
    if valid_url?
      respond_to do |format|
        format.html
        format.md { response.headers['X-Robots-Tag'] = 'noindex' }
        format.json { render json: @post }
      end
    else
      redirect_to_valid_slug
    end
  end

  def edit
    redirect_to edit_post_path @post unless valid_url?
  end

  def update
    if @post.update(post_params)
      @post.publish if params[:published] && !@post.published?
      SocialMessaging::TwitterStatus.new(@post).post_to_twitter
      redirect_to @post, notice: "#{display_name(@post)}updated"
    else
      render :edit
    end
  end

  def sorted_channels
    Channel.order name: :asc
  end
  helper_method :sorted_channels

  def like
    post = Post.find_by(slug: params[:slug])
    respond_to do |format|
      if post.increment_likes
        format.json { render json: { likes: post.likes } }
        format.html { redirect_to post }
      end
    end
  end

  def unlike
    post = Post.find_by(slug: params[:slug])
    respond_to do |format|
      if post.decrement_likes
        format.json { render json: { likes: post.likes } }
        format.html { redirect_to post }
      end
    end
  end

  def drafts
    @posts = posts_with_developer_and_channel.drafts

    @posts = @posts.where(developer: current_developer) unless current_developer.admin?

    render :index
  end

  private

  def process_post
    if params[:published]
      @post.publish
      SocialMessaging::TwitterStatus.new(@post).post_to_twitter
      root_path
    else
      drafts_path
    end
  end

  def posts_with_developer_and_channel
    Post.includes(:developer, :channel).page(params[:page]).per(15)
  end

  def redirect_to_valid_slug
    respond_to do |format|
      format.md { redirect_to post_text_path(@post) }
      format.html { redirect_to @post }
    end
  end

  def post_params
    params.require(:post).permit :body, :channel_id, :title
  end

  def untitled_slug
    params[:titled_slug].split('-').first
  end

  def set_post
    @post = Post.includes(:developer).find_by!(slug: untitled_slug)
  end

  def authorize_developer
    redirect_to root_path, alert: 'You can only edit your own posts' unless editable?(@post)
  end

  def no_self_like
    post = Post.find_by(slug: params[:slug])
    redirect_to root_path unless current_developer && (current_developer != post.developer)
  end

  def valid_url?
    @post.to_param == params[:titled_slug]
  end

  def display_name(post)
    post.published? ? 'Post ' : 'Draft '
  end
end
