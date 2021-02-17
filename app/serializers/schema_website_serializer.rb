# frozoen_string_literal: true

class SchemaWebsiteSerializer < SchemaBaseSerializer

  def to_jsonld_data
    base.merge(potential_action).to_json
  end

  def base
    {
        '@context': 'http://schema.org',
        '@type': 'Website',
        'url': context.root_url,
        'name': 'MagmaLabs TIL',
        'headline': 'Today I Learned',
        'copyrightYear': Date.today.year
    }
  end

  def potential_action
    {
        'potentialAction': {
            '@type': 'SearchAction',
            'target': "#{context.root_url}?q={query}",
            'query': 'required',
            'query-input': 'required name=query'
        }
    }
  end
end
