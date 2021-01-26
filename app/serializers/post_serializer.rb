# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  include MarkdownHelper

  attributes :id, :body, :created_at, :updated_at, :title, :slug, :likes, :published_at

  def body
    markdown.render(object.body)
  end

  has_one :developer
  has_one :channel
end
