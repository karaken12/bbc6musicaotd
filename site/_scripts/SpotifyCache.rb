class SpotifyCache
  CACHE_FILE_NAME = '_data/cache/spotify.yml'

  def initialize()
    #config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
    #$app_config = YAML.load_file(config_path)
    @cache = YAML.load_file(CACHE_FILE_NAME)
  end

  def is_cached?(album_id)
    return @cache.has_key?(album_id)
  end

  def get_album(album_id)
    if !@cache.has_key?(album_id)
      spotify_album = RSpotify::Album.find(album_id)
      @cache[album_id] = get_candidate(spotify_album)
    end

    return @cache[album_id]
  end

  def write()
    file = File.open(CACHE_FILE_NAME, 'w')
    file.puts @cache.to_yaml
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

end
