xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1', 'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1' do
  xml.url do
    xml.loc root_url
  end
  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.strftime('%Y-%m-%d')
    end
  end
  @channels.each do |channel|
    xml.url do
      xml.loc channel_url(channel)
      xml.lastmod channel.updated_at.strftime('%Y-%m-%d')
    end
  end
  @developers.each do |developer|
    xml.url do
      xml.loc developer_url(developer.username)
      xml.lastmod developer.updated_at.strftime('%Y-%m-%d')
    end
  end
end
