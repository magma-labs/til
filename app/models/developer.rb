# frozen_string_literal: true

class Developer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  before_create :set_username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :posts

  validates :email,
            presence: true,
            format: { with: /\A(.+@(#{ENV['permitted_domains']}))\z/,
                      message: 'must be from Magma' }

  validates :twitter_handle, length: { maximum: 15 },
                             format: { with: /\A(?=.*[a-z])[a-z_\d]+\Z/i }, allow_blank: true

  def self.editor_options
    ['Text Field', 'Ace (w/ Vim)', 'Ace'].freeze
  end

  validates :editor, inclusion: {
      in: editor_options,
      message: '%<value> is not a valid editor'
  }

  def to_param
    username
  end

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

  def set_username
    self.username = email[/^[^@]+/].tr('.', '')
  end
end
