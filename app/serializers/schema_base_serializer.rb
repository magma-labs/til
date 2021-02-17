# frozen_string_literal: true

# Base class to create Organization object
class SchemaBaseSerializer
  attr_reader :context

  def initialize(context)
    @context = context
  end

  def to_jsonld_data
    raise 'Implement in subclass'
  end
end
