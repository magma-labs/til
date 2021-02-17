# frozen_string_literal: true

module WithEntries
  extend ActiveSupport::Concern

  included do
    scope :with_entries, -> { joins(:posts).distinct }
  end
end
