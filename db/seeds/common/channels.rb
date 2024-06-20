channels = [
    { name: 'command-line', twitter_hashtag: 'commandline' },
    { name: 'computer-science', twitter_hashtag: 'computerscience' },
    { name: 'design', twitter_hashtag: 'design' },
    { name: 'devops', twitter_hashtag: 'devops' },
    { name: 'CD/CI', twitter_hashtag: 'CICD' },
    { name: 'git', twitter_hashtag: 'git' },
    { name: 'html-css', twitter_hashtag: 'htmlcss' },
    { name: 'javascript', twitter_hashtag: 'javascript' },
    { name: 'life-pro-tips', twitter_hashtag: 'lpt' },
    { name: 'mobile', twitter_hashtag: 'mobile' },
    { name: 'productivity', twitter_hashtag: 'productivity' },
    { name: 'quality-of-life', twitter_hashtag: 'qualityoflife' },
    { name: 'rails', twitter_hashtag: 'rails' },
    { name: 'react', twitter_hashtag: 'react' },
    { name: 'ruby', twitter_hashtag: 'ruby' },
    { name: 'sql', twitter_hashtag: 'sql' },
    { name: 'testing', twitter_hashtag: 'testing' },
    { name: 'vim', twitter_hashtag: 'vim' },
    { name: 'vue', twitter_hashtag: 'vue' },
    { name: 'workflow', twitter_hashtag: 'workflow' },
    { name: 'ai', twitter_hashtag: 'ai' }
]

channels.each do |channel|
  Channel.find_or_create_by!(name: channel[:name], twitter_hashtag: channel[:twitter_hashtag])
end
