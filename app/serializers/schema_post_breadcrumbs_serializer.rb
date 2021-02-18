# frozen_string_literal: true

class SchemaPostBreadcrumbsSerializer < SchemaBreadcrumbsSerializer
  attr_reader :post

  def initialize(context, post)
    super(context)
    @post = post
  end

  def entries
    [
        {
            url: context.root_url,
            name: 'MagmaLabs TIL'
        },
        {
            url: context.channel_url(post.channel),
            name: post.channel_name
        },
        {
            url: context.post_url(post),
            name: post.title
        },
    ]
  end
end
