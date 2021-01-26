# frozen_string_literal: true

require 'rails_helper'

describe Developer do
  let(:developer) { FactoryBot.build(:developer) }

  it 'has a valid factory' do
    expect(developer).to be_valid
  end

  it 'requires a username' do
    developer.username = ''
    expect(developer).not_to be_valid
  end

  it 'requires an email' do
    developer.email = ''
    expect(developer).not_to be_valid
  end

  context 'validates email domains' do
    it 'and allows whitelisted email addresses' do
      developer.email = 'johnsmith@whitelisted-guest.com'
      expect(developer).to be_valid
    end

    it 'and allows whitelisted domains' do
      developer.email = 'foo@hashrocket.com'
      expect(developer).to be_valid
      developer.email = 'foo@hshrckt.com'
      expect(developer).to be_valid
    end

    it 'denies an email from a non-whitelisted domain' do
      developer.email = 'foo@haxor.net'
      expect(developer).not_to be_valid
      expect(developer.errors.messages[:email]).to eq ['is invalid']
    end
  end

  context 'validates usernames' do
    it 'validates username uniqueness' do
      FactoryBot.create(:developer, username: developer.username)
      dup_developer = FactoryBot.build(:developer, username: developer.username)
      expect(dup_developer).not_to be_valid
      expect(dup_developer.errors.messages[:username]).to eq ['has already been taken']
    end

    it 'allows alphanumeric usernames' do
      alpha_numeric_developer = FactoryBot.build(:developer, username: 'johnsmith123')
      expect(alpha_numeric_developer).to be_valid
    end

    it 'denies usernames that contain other characters' do
      non_alpha_developer = FactoryBot.build(:developer, username: 'john_smith.123')
      expect(non_alpha_developer).not_to be_valid
      expect(non_alpha_developer.errors.messages[:username]).to eq ['is invalid']
    end
  end

  it 'sets admin as false on create' do
    expect(developer.admin).to eq false
  end

  context 'twitter username should be validated' do
    it 'is alphanumeric' do
      developer.twitter_handle = 'abc...'
      expect(developer).not_to be_valid
    end

    it 'is not all numbers' do
      developer.twitter_handle = '999'
      expect(developer).not_to be_valid
    end

    context 'is valid if it contains at least one alphabet character' do
      specify 'at the end' do
        developer.twitter_handle = '999a'
        expect(developer).to be_valid
      end

      specify 'at the beginning' do
        developer.twitter_handle = 'a999'
        expect(developer).to be_valid
      end
    end

    it 'is not more than 15 characters' do
      developer.twitter_handle = 'a' * 16
      expect(developer).not_to be_valid
    end

    it 'removes any leading @ symbols' do
      developer.twitter_handle = '@@@@hashrocket'
      expect(developer.twitter_handle).to eq 'hashrocket'
    end

    it 'does not allow blank' do
      developer.twitter_handle = ''
      expect(developer).to be_valid
      expect(developer.twitter_handle).to eq nil
    end

    describe '#slack_name=' do
      it 'saves nil when argument is blank' do
        developer.slack_name = ''
        expect(developer.slack_name).to eq nil
      end
    end

    describe '#slack_display_name' do
      it 'returns a slack_name when not nil' do
        developer.slack_name = 'slack-guy'
        developer.username = 'standard-guy'

        expect(developer.slack_display_name).to eq 'slack-guy'
      end

      it 'returns a username when slack_name is nil' do
        developer.slack_name = ''
        developer.username = 'standard-guy'

        expect(developer.slack_display_name).to eq 'standard-guy'
      end
    end

    context 'can contain an underscore' do
      specify 'as the leading character' do
        developer.twitter_handle = '_writer'
        expect(developer).to be_valid
      end

      specify 'anywhere else in the handle' do
        developer.twitter_handle = 'code_writer'
        expect(developer).to be_valid
      end
    end
  end

  context 'editor should be validated' do
    it 'onlies allow defined editor options' do
      developer.editor = 'not vim'
      expect(developer).to be_invalid
    end

    it 'can use defined editor options' do
      developer.editor = described_class.editor_options.sample
      expect(developer).to be_valid
    end
  end
end
