# frozen_string_literal: true

# Base class to create Organization object
class SchemaOrganizationSerializer < SchemaBaseSerializer

  def to_jsonld_data
    {
        '@context': 'http://schema.org',
        '@type': 'Organization',
        'url': context.root_url,
        'logo': context.image_url('magma-logo.svg')
    }.merge(same_as).to_json
  end

  private

  def same_as
    {
        'sameAs': %w[https://www.facebook.com/magmalabsio https://twitter.com/wearemagmalabs https://plus.google.com/109987647981559951163 https://github.com/magma-labs]
    }
  end
end
