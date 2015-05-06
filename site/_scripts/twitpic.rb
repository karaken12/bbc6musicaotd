
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
  id = album['twitter']
  puts id
  tweet = client.status(id)
  if tweet
    tweet_data = {}
    tweet_data['id'] = id
    tweet_data['created'] = tweet.created_at.to_s
    tweet_data['text'] = tweet.text
    if tweet.media?
      photo = tweet.media[0]
#      puts photo.media_url
#      puts photo.sizes
      #album['twitpic'] = tweet.media[0].media_url.to_s()
      tweet_data['media'] = {'url' => photo.media_url.to_s(), 'sizes'=>{}}
      
      photo.sizes.each{|k,size| tweet_data['media']['sizes'][k] = {'w'=>size.w, 'h'=>size.h, 'resize'=>size.resize}}
    end
    album['tweet'] = tweet_data
    if !(album['date'])
      album['date'] = Date.parse(tweet.created_at.to_s)
    end
  end
end

def process_data(data)  
  client = Twitter::REST::Client.new do |config|
    config.consumer_key = $app_config['twitter_consumer_key']
    config.consumer_secret = $app_config['twitter_consumer_secret']
  end

  data.each do |album|
    if !album.has_key?('twitter') then next end
    if !album['tweet']
      process_album(client, album)
    end
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

