
require 'rspotify'
require 'yaml'
require_relative 'SpotifyCache'

def update_file(file_name)
  data = YAML.load_file(file_name)
  cache = SpotifyCache.new()

  process_data(cache, data)

  cache.write()
end

def process_data(cache, data)
  data.each do |album|
    if !album.has_key?('spotify-id') then next end
    album_id = album['spotify-id']
    if cache.is_cached?(album_id) then next end
    # Otherwise get the new data.
    puts "Getting Spotify data for #{album['title']}."
    cache.get_album(album_id)
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

