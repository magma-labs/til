# frozen_string_literal: true

require 'rails_helper'

describe PostsController do
  xdescribe '#create' do
    let(:developer) { FactoryBot.create :developer }

    before do
      controller.sign_in developer
    end

    it 'denies non-whitelisted attributes' do
      post_attributes = FactoryBot.build(:post).attributes

      bad_attrs = {
          slug: '12345',
          id: 999,
          developer_id: 3,
          likes: 9,
          tweeted: true,
          max_likes: 10
      }

      post_attributes.merge!(bad_attrs)

      post :create, params: { post: post_attributes }

      last_post = Post.last
      bad_attrs.each do |k, v|
        expect(last_post[k.to_s]).not_to eq v
      end
    end
  end
  describe '#update' do
    let(:not_my_post) { FactoryBot.create :post }

    context 'as a developer' do
      let(:developer) { FactoryBot.create :developer }

      before do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
            provider: 'google_oauth2',
            uid: '12345678910',
            info: {
              email: developer.email,
                username: developer.username,
                admin: developer.admin
            }, credentials: {
                token: 'abcdefg12345',
                refresh_token: '12345abcdefg',
                expires_at: DateTime.now
            }
        })
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
      end

      it 'only allows me to update my own posts' do
        expect do
          patch :update, {
              params: {
                  titled_slug: not_my_post.to_param,
                  post: { title: 'HAXORD' }
              }
          }
        end.not_to change { not_my_post.reload.title }
      end

      it 'denies non-whitelisted attributes' do
        existing_post = FactoryBot.create(:post, tweeted: false, developer: developer)
        post_attributes = existing_post.attributes

        bad_attrs = { 'slug' => '12345',
                      'id' => 999,
                      'developer_id' => 3,
                      'likes' => 9,
                      'tweeted' => true,
                      'max_likes' => 10 }

        post_attributes.merge!(bad_attrs)

        put :update, params: {
            titled_slug: existing_post.to_param,
            post: post_attributes
        }

        last_post = Post.last
        bad_attrs.each do |k, v|
          expect(last_post[k]).not_to eq v
        end
      end

      it 'lists only my own drafts' do
        FactoryBot.create_list :post, 3, :draft, developer: developer
        FactoryBot.create_list :post, 3, developer: developer
        FactoryBot.create_list :post, 3, :draft
        get :drafts

        expect(developer.posts.drafts.length).to eq(3)
      end
    end

    xcontext 'as an admin' do
      let(:admin) { FactoryBot.create :developer, admin: true }

      before do
        controller.sign_in admin
      end

      it 'allows me to update anyones post' do
        expect do
          patch :update, params: {
              titled_slug: not_my_post.to_param,
              post: { title: 'this is ok' }
          }
        end.to change { not_my_post.reload.title }
      end
    end
  end

  describe '#index' do
    it 'returns a list of published posts' do
      FactoryBot.create_list(:post, 3)
      FactoryBot.create(:post, :draft)

      get :index
      expect(assigns(:posts).map(&:published?).uniq == [true]).to eq(true)
    end
  end

  describe '#show' do
    render_views

    context 'with not post' do
      it 'is a 404 when the post is not there' do
        expect do
          get :show, params: { titled_slug: 'asdf' }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with markdown extension' do
      it 'returns raw content' do
        developer = FactoryBot.create(:developer, username: 'jackdonaghy')

        raw_post = FactoryBot.create(:post,
                                     body: 'Raw content here',
                                     published_at: Time.zone.local(2016, 0o1, 0o1, 12),
                                     developer: developer,
                                     title: 'Plaintext Title')

        get :show, params: { titled_slug: raw_post.to_param, format: 'md' }

        expected = <<~RAW
        Plaintext Title

        Raw content here

        jackdonaghy
        January 1, 2016
        RAW

        expect(response.body).to eq expected
        expect(response.headers).to include('X-Robots-Tag')
        expect(response.headers['X-Robots-Tag']).to eq 'noindex'
      end

      it 'returns sanitized characters' do
        developer = FactoryBot.create(:developer, username: 'jackdonaghy')

        raw_post = FactoryBot.create(:post,
                                     body: 'Raw "quotes" here',
                                     published_at: Time.zone.local(2016, 0o1, 0o1, 12),
                                     developer: developer,
                                     title: '"Quotable" Title')

        get :show, params: { titled_slug: raw_post.to_param, format: 'md' }

        expected = <<~RAW
        "Quotable" Title

        Raw "quotes" here

        jackdonaghy
        January 1, 2016
        RAW

        expect(response.body).to eq expected
      end
    end
  end

  describe '#drafts' do
    context 'when I am a non-admin' do
      let(:developer2) { FactoryBot.create :developer }
      let(:rando) { FactoryBot.create :developer }

      before do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
            provider: 'google_oauth2',
            uid: '12345678910',
            info: {
              email: developer2.email,
                username: developer2.username,
                admin: developer2.admin
            }, credentials: {
                token: 'abcdefg12345',
                refresh_token: '12345abcdefg',
                expires_at: DateTime.now
            }
        })
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
      end

      it 'lists only my drafts' do
        FactoryBot.create_list :post, 3, developer: developer2
        FactoryBot.create_list :post, 3, :draft, developer: developer2

        FactoryBot.create_list :post, 3, developer: rando
        FactoryBot.create_list :post, 3, :draft, developer: rando
        get :drafts

        expect(developer2.posts.drafts.length).to eq(3)
      end
    end

    context 'when I am an admin developer' do
      let(:developer3) { FactoryBot.create :developer, admin: true }
      let(:rando) { FactoryBot.create :developer }

      before do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
            provider: 'google_oauth2',
            uid: '12345678910',
            info: {
              email: developer3.email,
                username: developer3.username,
                admin: developer3.admin
            }, credentials: {
                token: 'abcdefg12345',
                refresh_token: '12345abcdefg',
                expires_at: DateTime.now
            }
        })
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
      end

      it 'lists all drafts' do
        FactoryBot.create_list :post, 3, developer: developer3
        FactoryBot.create_list :post, 3, :draft, developer: developer3

        FactoryBot.create_list :post, 3, developer: rando
        FactoryBot.create_list :post, 3, :draft, developer: rando
        get :drafts

        expect(Post.drafts.length).to eq(6)
      end
    end
  end
end
