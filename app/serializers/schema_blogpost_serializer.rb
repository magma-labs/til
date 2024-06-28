# frozoen_string_literal: true

class SchemaBlogpostSerializer < SchemaBaseSerializer
  attr_reader :entry

  def initialize(context, entry)
    super(context)
    @entry = entry
  end

  def to_jsonld_data
    base.merge(main_entry, author, publisher).to_json
  end

  def base
    {
        '@context': 'http://schema.org',
        '@type': 'BlogPosting',
        'headline': entry.title,
        'alternativeHeadline': 'MagmaLabs Today I Learned',
        'datePublished': entry.created_at.strftime('%Y-%m-%d'),
        'dateModified': entry.updated_at.strftime('%Y-%m-%d'),
        'articleBody': entry.body,
        'image': context.image_url('logo.png'),
        'inLanguage': 'en-US',
        'copyrightYear': entry.created_at.year,
        'keywords': [entry.channel_name, 'MagmaLabs TIL', 'BlogPost', 'Today I Learned'],
        'publisher': 'MagmaLabs'
    }
  end

  def main_entry
    {
        'mainEntityOfPage': {
            '@type':'WebPage',
            '@id': context.post_url(entry)
        }
    }
  end

  def author
    {
        'author': {
            '@type': 'Person',
            'name': entry.developer_username,
            'url': context.developer_url(entry.developer)
        }
    }
  end

  def publisher
    {
        'publisher': {
            '@type': 'Organization',
            'name': 'MagmaLabs',
            'url': 'https://www.magmalabs.io',
            'logo': {
                '@type': 'ImageObject',
                'url': context.image_url('magma-logo.svg')
            }
        }
    }
  end
end
