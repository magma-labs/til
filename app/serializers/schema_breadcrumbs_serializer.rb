# frozoen_string_literal: true

class SchemaBreadcrumbsSerializer < SchemaBaseSerializer

  def to_jsonld_data
    base.to_json
  end

  def base
    {
        '@context': 'http://schema.org',
        '@type': 'BreadcrumbList',
        'itemListElement': item_list_element
    }
  end

  def item_list_element
    entries.map.with_index do |entry, index|
      {
          '@type': 'ListItem',
          'position': index + 1,
          'item': {
              '@id': entry[:url],
              'name': entry[:name]
          }
      }
    end
  end

  def entries
    raise 'Implement in subclass array of hashes with :url and :name'
  end
end
