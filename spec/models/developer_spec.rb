# frozen_string_literal: true

require 'rails_helper'

describe Developer do
  let(:developer) { FactoryBot.build(:developer) }

  it 'has a valid factory' do
    expect(developer).to be_valid
  end

  context 'validates usernames' do
    it 'allows alphanumeric usernames' do
      alpha_numeric_developer = FactoryBot.build(:developer, username: 'johnsmith123')
      expect(alpha_numeric_developer).to be_valid
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
    it 'can use defined editor options' do
      developer.editor = described_class.editor_options.sample
      expect(developer).to be_valid
    end
  end
end
