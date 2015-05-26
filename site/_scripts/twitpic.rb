
require 'yaml'
require_relative 'TwitterCache'

def update_file(file_name)
  albums = YAML.load_file(file_name)
  cache = TwitterCache.new()

  update_cache(cache, albums)

  cache.write()

  file = File.open(file_name, 'w')
  file.puts albums.to_yaml
  file.close
end

def update_cache(cache, albums)
  albums.each do |album|
    if !album.has_key?('twitter') then next end
    if cache.is_cached?(album['twitter']) then next end
    tweet = cache.get_tweet(album['twitter'])
    if tweet and !(album['date'])
      album['date'] = Date.parse(tweet['created'])
    end
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

