
require 'yaml'
require_relative 'TwitterCache'
require_relative 'SpotifyCache'
require_relative 'SpotifySearch'
require_relative '_questions'

def update_file(file_name)
  data = YAML.load_file(file_name)
  twitter_cache = TwitterCache.new()
  spotify_cache = SpotifyCache.new()

  data = process_data(twitter_cache, spotify_cache, data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close

  twitter_cache.write()
  spotify_cache.write()
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
  artist_album_data = ask_for_twitter_data(tweet, {'artist'=>'', 'title'=>''})
  artist = artist_album_data['artist']
  title = artist_album_data['title']

  # Search Spotify
  spotify_data = SpotifySearch.get_spotify_data(title, artist, nil)

  # Ask for Spotify confirmation
  selected_id = nil
  if spotify_data.has_key?('selected')
    selected_id = spotify_data['selected']['album_id']
  end
  chosen_index = choose_candidates(spotify_data['candidates'], selected_id)

  if chosen_index == nil
    spotify_id = nil
  else
    spotify_id = spotify_data['candidates'][chosen_index]['album_id']
  end

  # (Give the option to update the Artist / Album based on this choice)
  if spotify_id != nil
    spotify_album = spotify_cache.get_album(spotify_id)
    artist_album_data = ask_for_twitter_data(tweet, artist_album_data)
    artist = artist_album_data['artist']
    title = artist_album_data['title']
  end

  # Construct album object
  album = {'artist' => artist, 'title' => title}
  album['twitter'] = tweet_id
  album['date'] = Date.parse(tweet['created'])
  if spotify_id
    album['spotify-id'] = spotify_id
  else
    album['spotify'] = spotify_data
  end

  return album
end

def process_data(twitter_cache, spotify_cache, data)
  new_data = data
  while true
    album = get_album(twitter_cache, spotify_cache)
    if album == nil then break end
    new_data.push(album)
  end
  return new_data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

