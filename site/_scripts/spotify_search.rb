
require 'rspotify'
require 'yaml'

config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
$app_config = YAML.load_file(config_path)

def update_file(file_name)
  data = YAML.load_file(file_name)

  process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def get_candidate(album)
  return {
    'artists'  => album.artists.map{|a| a.name},
    'name'     => album.name,
    'album_id' => album.id,
    'type'     => album.album_type
  }
end

def process_data(data)
  data.each do |album|
    if album.has_key?('spotify-id') then next end
    if (album['spotify'] and !(album['spotify']['candidates'])) then next end
    if !album['title']
      #puts "= Title missing for item on #{album['date']}"
      next
    end
    if !album['artist'] and album['type']!='compilation'
      puts "= Artist missing for item on #{album['date']}"
      next
    end

    search_string = "album:\"#{album['title']}\""
    if (album['artist'])
      search_string += "+artist:\"#{album['artist']}\""
    end

    spotify_albums = RSpotify::Album.search(search_string, market: 'GB')

    type='album'
    if (album['type'])
      type = album['type']
    end
    spotify_albums_sel = spotify_albums.select{|sa| sa.album_type == type}

    puts "- Search for #{album['title']} by #{album['artist']}"
    puts "  Found #{spotify_albums.total} (#{spotify_albums_sel.count} selected)"
    if (spotify_albums.count > 0)
      album['spotify'] = {}
      if (spotify_albums_sel.count == 1)
        album['spotify']['selected'] = get_candidate(spotify_albums_sel[0])
      end
      album['spotify']['candidates'] = spotify_albums.map{|sa| get_candidate(sa)}
    end
    #puts "  Search at: https://api.spotify.com/v1/search?q=#{search_string}&type=album&market=GB"

  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

