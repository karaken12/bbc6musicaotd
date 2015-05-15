
require 'yaml'

CACHE_FILE_NAME = "_data/cache/twitter.yml"

def update_file(file_name)
  data = YAML.load_file(file_name)
  cache = YAML.load_file(CACHE_FILE_NAME)

  data = process_data(cache, data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_data(cache, data)
  data.each do |album|
    if album.has_key?('spotify') or album.has_key?('spotify-id')
      # Assume it's fine
      next
    end
    puts "==="
    if !album.has_key?('twitter')
      puts "No Tweet for #{album['date']}."
      next
    end
    tweet_id = album['twitter']
    if !cache.has_key?(tweet_id)
      puts "No tweet data for #{tweet_id} (#{album['date']})."
      next
    end
    tweet = cache[tweet_id]
    if !tweet.has_key?('text')
      puts "No tweet text on #{tweet_id} (#{album['date']})."
      next
    end
    puts "Twitter: #{tweet['text']}"
    print "Enter artist (#{album['artist']}): "
    artist = STDIN.gets.chomp
    if artist != ''
      album['artist'] = artist
    end
    print "Enter title (#{album['title']}): "
    title = STDIN.gets.chomp
    if title != ''
      album['title'] = title
    end
  end
  return data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

