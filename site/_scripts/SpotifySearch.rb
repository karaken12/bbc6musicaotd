
require 'rspotify'

module SpotifySearch
  config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
  $app_config = YAML.load_file(config_path)

  def SpotifySearch.get_candidate(album)
    return {
      'artists'  => album.artists.map{|a| a.name},
      'name'     => album.name,
      'album_id' => album.id,
      'type'     => album.album_type
    }
  end

  def SpotifySearch.get_spotify_data(title, artist, type)
    spotify_data = nil

    search_string = "album:\"#{title}\""
    if (artist)
      search_string += "+artist:\"#{artist}\""
    end

    spotify_albums = RSpotify::Album.search(search_string, market: 'GB')

    if type == nil
      type = 'album'
    end
    spotify_albums_sel = spotify_albums.select{|sa| sa.album_type == type}

    puts "- Search for #{title} by #{artist}"
    puts "  Found #{spotify_albums.total} (#{spotify_albums_sel.count} selected)"
    if (spotify_albums.count > 0)
      spotify_data = {}
      if (spotify_albums_sel.count == 1)
        spotify_data['selected'] = get_candidate(spotify_albums_sel[0])
      end
      spotify_data['candidates'] = spotify_albums.map{|sa| get_candidate(sa)}
    end
    #puts "  Search at: https://api.spotify.com/v1/search?q=#{search_string}&type=album&market=GB"

    return spotify_data
  end

end
