# frozen_string_literal: true

require 'rails_helper'

describe SocialMessaging::TwitterStatus do
  let(:developer) do
    FactoryBot.create(:developer, username: 'cooldeveloper', twitter_handle: 'handle')
  end
  let(:channel) do
    FactoryBot.create(:channel, name: 'dreamwave', twitter_hashtag: 'yodreamhashtag')
  end

  let(:post) do
    FactoryBot.build(:post,
                     title: 'Cool post',
                     slug: '1234',
                     developer: developer,
                     channel: channel)
  end

  let(:twitter_status) { described_class.new(post) }

  describe '#status' do
    it 'returns a Twitter status' do
      host = 'til.magmalabs.io'
      expected = "Cool post http://#{host}/posts/1234-cool-post via @handle #til #yodreamhashtag"
      actual = twitter_status.send(:status)

      expect(actual).to eq expected
    end
  end
end
