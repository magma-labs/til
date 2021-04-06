# frozen_string_literal: true

# rubocop:disable Rails/Output
Dir[Rails.root.join('db/seeds/common/*.rb')].each do |file|
  puts "\n Loading file #{file.split(%r{/}).last}"
  require file
end

seed_file = Rails.root.join("db/seeds/#{Rails.env}.rb")
if seed_file.exist?
  puts "\n *** Loading #{Rails.env} seed data"
  require seed_file
end
# rubocop:enable Rails/Output
