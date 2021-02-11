# frozen_string_literal: true

# To download production data instead of these seeds, run
# rake db:restore_production_dump

channels = [
    { name: 'command-line', twitter_hashtag: 'commandline' },
    { name: 'computer-science', twitter_hashtag: 'computerscience' },
    { name: 'design', twitter_hashtag: 'design' },
    { name: 'devops', twitter_hashtag: 'devops' },
    { name: 'CD/CI', twitter_hashtag: 'CICD' },
    { name: 'git', twitter_hashtag: 'git' },
    { name: 'html-css', twitter_hashtag: 'htmlcss' },
    { name: 'javascript', twitter_hashtag: 'javascript' },
    { name: 'mobile', twitter_hashtag: 'mobile' },
    { name: 'rails', twitter_hashtag: 'rails' },
    { name: 'react', twitter_hashtag: 'react' },
    { name: 'ruby', twitter_hashtag: 'ruby' },
    { name: 'sql', twitter_hashtag: 'sql' },
    { name: 'testing', twitter_hashtag: 'testing' },
    { name: 'vim', twitter_hashtag: 'vim' },
    { name: 'workflow', twitter_hashtag: 'workflow' }
]

print "Creating #{channels.length} channels"
channels.each do |channel|
  Channel.find_or_create_by!(name: channel[:name], twitter_hashtag: channel[:twitter_hashtag])
end
puts ' ...done.'

print 'Creating developers'
5.times do
  username = Faker::Movies::VForVendetta.unique.character.downcase.delete(' ')
  Developer.create!(username: username,
                    email: "#{username}@magmalabs.io")
end
puts ' ...done.'

print 'Creating posts'
400.times do
  channel = Channel.all.sample
  likes = rand(1..20)
  length = rand(10..50)

  Post.create!(channel: channel,
               title: Faker::Lorem.sentence(word_count: 3),
               body: Faker::Lorem.paragraph(sentence_count: length),
               developer: Developer.all.sample,
               likes: likes,
               max_likes: likes,
               created_at: Time.zone.today - rand(30).days,
               published_at: [(Time.zone.today - rand(30).days), nil].sample)
end
puts '...done.'
