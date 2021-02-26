# frozen_string_literal: true

require 'rails_helper'

describe Post do
  let(:post) { FactoryBot.create(:post) }
  let(:valid_title) { 'today-i-learned-about-clojure' }

  it 'has a valid factory' do
    expect(post).to be_valid
  end

  it 'requires a body' do
    post.body = ''
    expect(post).not_to be_valid
  end

  it 'has a like count that defaults to one' do
    expect(post.likes).to eq 1
  end

  it 'requires a developer' do
    post.developer = nil
    expect(post).not_to be_valid
  end

  it 'requires a channel' do
    post.channel = nil
    expect(post).not_to be_valid
  end

  it 'requires a title' do
    post.title = nil
    expect(post).not_to be_valid
  end

  describe '#generate_slug' do
    it 'creates a slug' do
      expect(post.slug).to be
    end

    it 'allows a custom slug' do
      custom_slugged_post = FactoryBot.create(:post, slug: '1234')
      expect(custom_slugged_post.slug).to eq '1234'
    end
  end

  describe '#slugified_title' do
    it 'creates a slug with dashes' do
      post.title = 'Today I learned about clojure'
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it 'creates a slug without multiple dashes' do
      post.title = 'Today I learned --- about clojure'
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it 'uses title dashes in slug' do
      post.title = 'Today I learned about clojure-like syntax feature'
      expect(post.send(:slugified_title)).to eq 'today-i-learned-about-clojure-like-syntax-feature'
    end

    it 'removes whitespace from slug' do
      post.title = '  Today I             learned about clojure   '
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it 'does not allow punctuation in slug' do
      post.title = 'Today I! learned? & $ % about #clojure'
      expect(post.send(:slugified_title)).to eq valid_title
    end

    it 'ignores and strip emojis' do
      post.title = 'Today I learned about clojure 😀'
      expect(post.send(:slugified_title)).to eq valid_title
    end
  end

  describe '#search' do
    it 'finds by developer' do
      needle = %w[brian jake].map do |author_name|
        FactoryBot.create :post, developer: FactoryBot.create(:developer, username: author_name)
      end.last

      expect(described_class.search('jake')).to eq [needle]
    end

    it 'finds by channel' do
      needle = %w[vim ruby].map do |channel_name|
        FactoryBot.create :post, channel: FactoryBot.create(:channel, name: channel_name)
      end.last

      expect(described_class.search('ruby')).to eq [needle]
    end

    it 'finds by title' do
      needle = %w[postgres sql].map do |title|
        FactoryBot.create :post, title: title
      end.last

      expect(described_class.search('sql')).to eq [needle]
    end

    it 'finds by body' do
      needle = %w[postgres sql].map do |body|
        FactoryBot.create :post, body: body
      end.last

      expect(described_class.search('sql')).to eq [needle]
    end

    it 'ranks matches by title, then developer or channel, then body' do
      posts = [
          FactoryBot.create(:post, body: 'needle'),
          FactoryBot.create(:post, channel: FactoryBot.create(:channel, name: 'needle')),
          FactoryBot.create(:post, developer: FactoryBot.create(:developer, username: 'needle')),
          FactoryBot.create(:post, title: 'needle')
      ].reverse

      ids = described_class.search('needle').pluck(:id)
      expect(ids[1..-2]).to match_array posts.map(&:id)[1..-2]
      expect([ids.first, ids.last]).to eq [posts.map(&:id).first, posts.map(&:id).last]
    end

    it 'breaks ties by post date' do
      FactoryBot.create(:post, title: 'older', body: 'needle', created_at: 2.days.ago)
      FactoryBot.create(:post, title: 'newer', body: 'needle')

      expect(described_class.search('needle').map(&:title)).to eq %w[newer older]
    end
  end

  it 'knows if its max likes count is a factor of ten' do
    method = :likes_threshold?

    post.max_likes = 10
    expect(post.send(method)).to eq true

    post.max_likes = 11
    expect(post.send(method)).to eq false
  end

  it 'nevers have a negative like count' do
    post.likes = -1

    expect(post).not_to be_valid
  end

  describe '#publish' do
    it 'sets the post to published = true' do
      post.publish
      expect(post.published_at).to be_present
    end
  end

  describe '.popular' do
    it 'returns published posts with five or more likes' do
      FactoryBot.create(:post, likes: 5)
      FactoryBot.create(:post, :draft, likes: 5)
      FactoryBot.create(:post, likes: 4)

      expect(described_class.popular.size).to eq 1
    end
  end

  context 'slack integration on publication' do
    describe 'new post, published is true' do
      it 'notifies slack' do
        post = FactoryBot.build(:post)

        expect(post).to receive(:notify_slack)
        post.save
      end
    end

    describe 'new post, published is false' do
      it 'does not notify slack' do
        post = FactoryBot.build(:post, :draft)

        expect(post).not_to receive(:notify_slack)
        post.save
      end
    end

    describe 'existing post, published changes to true' do
      it 'notifies slack' do
        post = FactoryBot.create(:post, :draft)
        post.published_at = Time.zone.now

        expect(post).to receive(:notify_slack)
        post.save
      end
    end
  end

  describe '#increment_likes' do
    it 'increments max likes when likes equals max likes' do
      post = FactoryBot.create(:post, likes: 5, max_likes: 5)

      post.increment_likes
      expect(post.likes).to eq 6
      expect(post.max_likes).to eq 6
    end

    it 'does not change max likes when likes are less than max likes' do
      post = FactoryBot.create(:post, likes: 3, max_likes: 5)

      post.increment_likes
      expect(post.likes).to eq 4
      expect(post.max_likes).to eq 5
    end
  end

  describe '#decrement_likes' do
    it 'does not change max likes' do
      post = FactoryBot.create(:post, likes: 5, max_likes: 5)

      post.decrement_likes
      expect(post.likes).to eq 4
      expect(post.max_likes).to eq 5
    end
  end

  context 'slack integration on tens of likes' do
    describe 'reaches the milestone more than once' do
      it 'notifies slack only once' do
        post = FactoryBot.create(:post, likes: 9, max_likes: 9)

        expect(post).to receive(:notify_slack).once
        post.increment_likes # 10
        post.decrement_likes # 9
        post.increment_likes # 10

        post.increment_likes # 11
        post.decrement_likes # 10
      end
    end
  end
end
