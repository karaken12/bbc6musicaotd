
require 'rspotify'
require 'yaml'

config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
$app_config = YAML.load_file(config_path)
CACHE_FILE_NAME = '_data/cache/spotify.yml'

def update_file(file_name)
  data = YAML.load_file(file_name)
  cache = YAML.load_file(CACHE_FILE_NAME)

  process_data(cache, data)

  file = File.open(CACHE_FILE_NAME, 'w')
  file.puts cache.to_yaml
  file.close
end

def get_candidate(album)
  return {
    'artists'  => album.artists.map{|a| a.name},
    'name'     => album.name,
    'album_id' => album.id,
    'type'     => album.album_type,
    'images'   => album.images
  }
end

def process_data(cache, data)
  data.each do |album|
    if !album.has_key?('spotify-id') then next end
    album_id = album['spotify-id']

    if cache.has_key?(album_id) then next end

    puts "Getting Spotify data for #{album['title']}."
    spotify_album = RSpotify::Album.find(album_id)
    
    cache[album_id] = get_candidate(spotify_album)
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

