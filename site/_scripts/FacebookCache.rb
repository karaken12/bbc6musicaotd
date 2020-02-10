
require 'koala'

class FacebookCache
  CACHE_FILE_NAME = '_data/cache/facebook.yml'

  def initialize()
    if File.exist?(CACHE_FILE_NAME)
      @cache = YAML.load_file(CACHE_FILE_NAME)
    else
      @cache = {}
    end

    config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
    app_config = YAML.load_file(config_path)
    @client = Koala::Facebook::API.new(app_config['facebook_access_token'])
  end

  def self.get_facebook_id_from_url(url)
    url_style_1 = /https:\/\/www\.facebook\.com\/BBCRadio6Music\/posts\/(\d+)(:0)?/
    url_style_2 = /https:\/\/www\.facebook\.com\/BBCRadio6Music\/photos\/.*\/(\d+)\/?.*/
    url_style_3 = /https:\/\/www\.facebook\.com\/\d*\/posts\/(\d+)\/?/
    id = url[url_style_1, 1]
    if id == nil
      id = url[url_style_2, 1]
    end
    if id == nil
      id = url[url_style_3, 1]
    end
    if id == nil
      puts "Error! Facebook URL not matched: #{url}"
    end
    #puts "Facebook: #{url}: #{id}"
    return id
  end

  def is_cached?(post_id)
    return @cache.has_key?(post_id)
  end

  def get_post(post_id)
    if !@cache.has_key?(post_id)
      post = get_post_int(post_id)
      if post
        @cache[post_id] = post
      end
    end

    return @cache[post_id]
  end

  def is_url_cached?(post_url)
    return is_cached?(FacebookCache.get_facebook_id_from_url(post_url))
  end

  def get_post_by_url(post_url)
    return get_post(FacebookCache.get_facebook_id_from_url(post_url))
  end

  def get_post_int(id)
    puts "Get Facebook post #{id}"
#    begin
      post = @client.get_object(id)
puts post['id']
puts post['name']
puts post['images']

    if post
      post_data = {}
      post_data['id'] = id
      post_data['created'] = post['created_time']
      post_data['text'] = post['name']
      if post.has_key?('images')
        post_data['images'] = post['images']
      end
      return post_data
    end

#    rescue Twitter::Error => e
#      puts "-- Failed: #{e.message}"
#      return nil
#    end
#    if tweet
#      tweet_data = {}
#      tweet_data['id'] = id
#      tweet_data['created'] = tweet.created_at.to_s
#      tweet_data['text'] = tweet.text
#      if tweet.media?
#        photo = tweet.media[0]
##        puts photo.media_url
##        puts photo.sizes
#        #album['twitpic'] = tweet.media[0].media_url.to_s()
#        tweet_data['media'] = {'url' => photo.media_url.to_s(), 'sizes'=>{}}
#
#        photo.sizes.each{|k,size| tweet_data['media']['sizes'][k] = {'w'=>size.w, 'h'=>size.h, 'resize'=>size.resize}}
#      end
#      return tweet_data
#    end
    return nil
  end

  def write()
    file = File.open(CACHE_FILE_NAME, 'w')
    file.puts @cache.to_yaml
    file.close
  end

end
