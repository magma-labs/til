# frozen_string_literal: true

class Ad < ApplicationRecord
  def self.random
    order("RANDOM()").first
  end
end
