
require 'yaml'
CACHE_FILE_NAME = "_data/cache/twitter.yml"

def update_file(file_name)
  data = YAML.load_file(file_name)
  if File.exist?(CACHE_FILE_NAME)
    cache = YAML.load_file(CACHE_FILE_NAME)
  else
    cache = {}
  end

  process_data(cache, data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close

  file = File.open(CACHE_FILE_NAME, 'w')
  file.puts cache.to_yaml
  file.close
end

def process_data(cache, data)
  data.each do |album|
    if !album.has_key?('tweet') then
      next
    end

    tweet_id = album['tweet']['id']
    cache[tweet_id] = album['tweet']
    album['twitter'] = tweet_id
    album.delete('tweet')
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

