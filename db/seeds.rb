# frozen_string_literal: true

Dir[Rails.root.join('db/seeds/common/*.rb')].sort.each do |file|
  puts "Loading file #{file.split(/\/./).last}"
  require file
end

seed_file = Rails.root.join("db/seeds/#{Rails.env}.rb")
if seed_file.exist?
  puts "*** Loading #{Rails.env} seed data"
  require seed_file
end
