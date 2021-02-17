# frozen_string_literal: true

class Developer < ApplicationRecord
  include WithEntries

  has_many :posts, dependent: :destroy

  validates :twitter_handle, length: { maximum: 15 },
                             format: { with: /\A(?=.*[a-z])[a-z_\d]+\Z/i }, allow_blank: true

  def self.editor_options
    ['Text Field', 'Ace (w/ Vim)', 'Ace'].freeze
  end

  validates :editor, inclusion: {
      in: editor_options,
      message: '%<value> is not a valid editor'
  }

  def twitter_handle=(handle)
    self[:twitter_handle] = handle.gsub(/^@+/, '').presence
  end

  def slack_name=(name)
    self[:slack_name] = name.presence
  end

  def posts_count
    posts.published.count
  end

  def slack_display_name
    slack_name || username
  end
end
