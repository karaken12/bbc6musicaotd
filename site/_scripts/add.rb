
require 'yaml'
require_relative 'TwitterCache'
require_relative 'SpotifyCache'
require_relative 'SpotifySearch'
require_relative 'AlbumData'
require_relative '_questions'

def update_file(file_name)
  data = YAML.load_file(file_name)
  twitter_cache = TwitterCache.new()
  spotify_cache = SpotifyCache.new()
  facebook_cache = nil

  data = process_data(twitter_cache, facebook_cache, spotify_cache, data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close

  twitter_cache.write()
  spotify_cache.write()
end

def get_facebook_album(facebook_cache, spotify_cache)
  puts "==="
  # Ask for URL
  print "Enter Facebook URL: "
  facebook_url = STDIN.gets.chomp
  if facebook_url == '' then return nil end
  artist_album_data = AlbumData.new('','','')

  # TODO: get Facebook data
  facebook_post = nil
  text = "Facebook: NOT IMPLEMENTED!"
  sources = {'facebook' => [facebook_url]}

  # Ask for Artist / Album
  artist_album_data = ask_for_album_data(text, artist_album_data)

  # Search Spotify
  spotify_data = SpotifySearch.get_spotify_data(artist_album_data.title, artist_album_data.artist, nil)

  spotify_id = nil
  if spotify_data
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
  end

  # (Give the option to update the Artist / Album based on this choice)
  if spotify_id != nil
    spotify_album = spotify_cache.get_album(spotify_id)
    artist_album_data = ask_for_album_data(text, artist_album_data)
  end

  # Construct album object
  album = {}
  album['artist'] = artist_album_data.artist
  album['title'] = artist_album_data.title
  album['date'] = Date.parse(artist_album_data.date)
  if spotify_id
    album['spotify-id'] = spotify_id
  end
  album['sources'] = sources

  return album
end

def get_twitter_album(twitter_cache, spotify_cache)
  puts "==="
  # Ask for Twitter URL
  print "Enter Tweet URL: "
  tweet_id = STDIN.gets.chomp
  if tweet_id == '' then return nil end
  artist_album_data = AlbumData.new('','','')

  # Get Twitter data
  tweet = twitter_cache.get_tweet(tweet_id)
  if tweet == nil then return nil end
  text = "Twitter: #{tweet['text']}"
  artist_album_data.date = Date.parse(tweet['created']).to_s()
  sources = {'twitter' => [tweet_id]}

  # Ask for Artist / Album
  artist_album_data = ask_for_album_data(text, artist_album_data)

  # Search Spotify
  spotify_data = SpotifySearch.get_spotify_data(artist_album_data.title, artist_album_data.artist, nil)

  spotify_id = nil
  if spotify_data
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
  end

  # (Give the option to update the Artist / Album based on this choice)
  if spotify_id != nil
    spotify_album = spotify_cache.get_album(spotify_id)
    artist_album_data = ask_for_album_data(text, artist_album_data)
  end

  # Construct album object
  album = {}
  album['artist'] = artist_album_data.artist
  album['title'] = artist_album_data.title
  album['date'] = Date.parse(artist_album_data.date)
  if spotify_id
    album['spotify-id'] = spotify_id
  end
  album['sources'] = sources

  return album
end

def process_data(twitter_cache, facebook_cache, spotify_cache, data)
  new_data = data
  while true
    album = get_facebook_album(twitter_cache, spotify_cache)
    if album == nil then break end
    new_data.push(album)
  end
  return new_data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

