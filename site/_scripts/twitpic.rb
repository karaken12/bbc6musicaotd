
require 'yaml'
require_relative 'TwitterCache'
require_relative 'FacebookCache'

def update_file(file_name)
  albums = YAML.load_file(file_name)
  cache = TwitterCache.new()
  fb_cache = FacebookCache.new()

  update_cache(cache, albums)
  cache.write()

  update_fb_cache(fb_cache, albums)
  fb_cache.write()

  file = File.open(file_name, 'w')
  file.puts albums.to_yaml
  file.close
end

def get_tweet_id(album)
  if album.has_key?('twitter')
    return album['twitter']
  end
  if album.has_key?('sources') && album['sources'].has_key?('twitter')
    return album['sources']['twitter'][0]
  end
  return nil
end

def get_facebook_url(album)
  if album.has_key?('sources') && album['sources'].has_key?('facebook')
    return album['sources']['facebook'][0]
  end
  return nil
end

def update_cache(cache, albums)
  albums.each do |album|
    tweet_id = get_tweet_id(album)
    if !tweet_id then next end
    if cache.is_cached?(tweet_id) then next end
    tweet = cache.get_tweet(tweet_id)
    if tweet and !(album['date'])
      album['date'] = Date.parse(tweet['created'])
    end
  end
end

def update_fb_cache(cache, albums)
  albums.each do |album|
    url = get_facebook_url(album)
    if !url then next end
    if cache.is_url_cached?(url) then next end
    post = cache.get_post_by_url(url)
    if post and !(album['date'])
      album['date'] = Date.parse(post['created'])
    end
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

