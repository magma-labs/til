require 'rails_helper'

RSpec.describe "Sitemaps", type: :request do
  describe "show" do
    context 'GET /sitemap' do
      it 'returns the xml with all the posts' do
        post = create(:post)
        get sitemap_path, format: :xml
        expect(response.body).to include(post.slug)
      end
    end
  end
end
