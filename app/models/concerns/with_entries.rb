# frozen_string_literal: true

module WithEntries
  extend ActiveSupport::Concern

  included do
    scope :with_entries, -> { joins(:posts).where.not(posts: { published_at: nil}).distinct }
  end
end
