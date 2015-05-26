
require 'twitter'

class TwitterCache
  CACHE_FILE_NAME = '_data/cache/twitter.yml'

  def initialize()
    if File.exist?(CACHE_FILE_NAME)
      @cache = YAML.load_file(CACHE_FILE_NAME)
    else
      @cache = {}
    end

    config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
    app_config = YAML.load_file(config_path)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = app_config['twitter_consumer_key']
      config.consumer_secret = app_config['twitter_consumer_secret']
    end
  end

  def is_cached?(tweet_uri)
    return @cache.has_key?(tweet_uri)
  end

  def get_tweet(tweet_uri)
    if !@cache.has_key?(tweet_uri)
      tweet = get_tweet_int(tweet_uri)
      if tweet
        @cache[tweet_uri] = tweet
      end
    end

    return @cache[tweet_uri]
  end

  def get_tweet_int(id)
    puts "Get tweet #{id}"
    begin
      tweet = @client.status(id)
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
#        puts photo.media_url
#        puts photo.sizes
        #album['twitpic'] = tweet.media[0].media_url.to_s()
        tweet_data['media'] = {'url' => photo.media_url.to_s(), 'sizes'=>{}}

        photo.sizes.each{|k,size| tweet_data['media']['sizes'][k] = {'w'=>size.w, 'h'=>size.h, 'resize'=>size.resize}}
      end
      return tweet_data
    end
    return nil
  end

  def write()
    file = File.open(CACHE_FILE_NAME, 'w')
    file.puts @cache.to_yaml
    file.close
  end

end
