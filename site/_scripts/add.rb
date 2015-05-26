
require 'yaml'
require_relative 'TwitterCache'
require_relative 'SpotifyCache'
require_relative '_questions'

def update_file(file_name)
  data = YAML.load_file(file_name)
  twitter_cache = TwitterCache.new()
  spotify_cache = SpotifyCache.new()

  data = process_data(twitter_cache, spotify_cache, data)

#  file = File.open(file_name, 'w')
#  file.puts data.to_yaml
#  file.close
end

def get_album(twitter_cache, spotify_cache)
  puts "==="
  # Ask for Twitter URL
  print "Enter Tweet URL: "
  tweet_id = STDIN.gets.chomp
  if tweet_id == '' then return nil end

  # Get Twitter data
  tweet = twitter_cache.get_tweet(tweet_id)
  if tweet == nil then return nil end

  # Ask for Artist / Album
  album = ask_for_twitter_data(tweet, {'artist'=>'', 'title'=>''})

  # Search Spotify
  # Ask for Spotify confirmation
  # (Give the option to update the Artist / Album based on this choice)

  # Construct album object
  album['twitter'] = tweet_id
  album['date'] = Date.parse(tweet['created'])

  return album
end

def process_data(twitter_cache, spotify_cache, data)

  new_data = data
  while true
    album = get_album(twitter_cache, spotify_cache)
    if album == nil then break end
    puts album
  end
  return new_data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

