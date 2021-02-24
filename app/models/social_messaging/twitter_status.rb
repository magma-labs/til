# frozen_string_literal: true

module SocialMessaging
  class TwitterStatus
    attr_reader :post

    def initialize(post)
      @post = post
    end

    def post_to_twitter
      return if post.draft? || post.tweeted

      return unless ENV['update_twitter_with_post'] == 'true'

      TwitterClient.update(status)
      post.tweeted = true
      post.save
    end

    private

    def title
      post.title
    end

    def name
      post.twitter_handle
    end

    def category
      post.channel.twitter_hashtag
    end

    def status
      "#{title} #{Rails.application.routes.url_helpers.post_url(titled_slug: post.to_param,
                                                                host: 'til.magmalabs.io')} via @#{name} #til ##{category}"
    end
  end
end
