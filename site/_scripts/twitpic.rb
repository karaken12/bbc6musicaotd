
require 'twitter'
require 'yaml'

config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
$app_config = YAML.load_file(config_path)
CACHE_FILE_NAME = "_data/cache/twitter.yml"

def update_file(file_name)
  albums = YAML.load_file(file_name)
  if File.exist?(CACHE_FILE_NAME)
    cache = YAML.load_file(CACHE_FILE_NAME)
  else
    cache = {}
  end

  update_cache(cache, albums)

  file = File.open(CACHE_FILE_NAME, 'w')
  file.puts cache.to_yaml
  file.close

  file = File.open(file_name, 'w')
  file.puts albums.to_yaml
  file.close
end

def get_tweet(client, id)
  puts "Get tweet #{id}"
  begin
    tweet = client.status(id)
  rescue Twitter::Error => e
    puts "-- Failed: #{e.message}"
    return nil
  end
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
    return tweet_data
  end
  return nil
end

def update_cache(cache, albums)
  client = Twitter::REST::Client.new do |config|
    config.consumer_key = $app_config['twitter_consumer_key']
    config.consumer_secret = $app_config['twitter_consumer_secret']
  end

  albums.each do |album|
    if !album.has_key?('twitter') then next end
    if !cache.has_key?(album['twitter'])
      tweet = get_tweet(client, album['twitter'])
      if tweet
        cache[album['twitter']] = tweet
        if !(album['date'])
          album['date'] = Date.parse(tweet['created'])
        end
      end
    end
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

