
require 'twitter'
require 'yaml'

config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
$app_config = YAML.load_file(config_path)

def update_file(file_name)
  data = YAML.load_file(file_name)

  process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_album(client, album)
    puts album['twitter']
    tweet = client.status(album['twitter'])
    if tweet and tweet.media?
#      photo = tweet.media[0]
#      puts photo.media_url
#      puts photo.sizes
#      puts photo.sizes[:thumb]
      album['twitpic'] = tweet.media[0].media_url.to_s()
    end
    album['tweet_text'] = tweet.text
end

def process_data(data)  
  client = Twitter::REST::Client.new do |config|
    config.consumer_key = $app_config['twitter_consumer_key']
    config.consumer_secret = $app_config['twitter_consumer_secret']
  end

  data.each do |album|
    if !album['twitter'] then next end
    # Only want to process if it has no picture, or it has no title.
    # (Don't want to unnecessarially store tweet_text.)
    if !album['twitpic']
      process_album(client, album)
      next
    end
    if !album['tweet_text'] and !album['title']
      process_album(client, album)
      next
    end
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

