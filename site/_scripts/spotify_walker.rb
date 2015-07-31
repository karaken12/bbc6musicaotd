
require 'yaml'
require_relative '_questions'

CANDIDATE_FILE_NAME = "_data/cache/spotify_candidates.yml"

def update_file(file_name)
  data = YAML.load_file(file_name)

  cached_data = YAML.load_file(CANDIDATE_FILE_NAME)[file_name]

  data = process_data(data, cached_data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_data(data, cached)
  data.each do |album|
    if album.has_key?('spotify-id')
      # Assume it's fine
      next
    end
    puts "==="
    spotify_data = get_spotify_data(cached, album)
    if !spotify_data || !spotify_data.has_key?('spotify')
      puts "No Spotify data for #{album['date']}."
      next
    end
    if !spotify_data['spotify'].has_key?('candidates')
      puts "No candidates for #{album['date']}."
      next
    end
    candidates = spotify_data['spotify']['candidates']
    selected_id = nil
    if spotify_data['spotify'].has_key?('selected')
      selected_id = spotify_data['spotify']['selected']['album_id']
    end
    puts "#{album['title']} by #{album['artist']}"
    if album.has_key?('notes')
      puts "(#{album['notes']})"
    end

    chosen_index = choose_candidates(candidates, selected_id)
    if chosen_index == nil then next end
    
    album['spotify-id'] = candidates[chosen_index]['album_id']
    #spotify_data.delete('spotify')
    #print "Enter artist (#{album['artist']}): "
    #artist = STDIN.gets.chomp
    #if artist != ''
    #  album['artist'] = artist
    #end
    #print "Enter title (#{album['title']}): "
    #title = STDIN.gets.chomp
    #if title != ''
    #  album['title'] = title
    #end
  end
  return data
end

def get_spotify_data(cached, album)
  def exists_and_equal(c,a,k)
    if c.has_key?(k) && a.has_key?(k)
      return c[k] == a[k]
    else
      return false
    end
  end

  cached.each do |cached_album|
    if exists_and_equal(cached_album, album, 'date') && exists_and_equal(cached_album, album, 'artist') && exists_and_equal(cached_album, album, 'title')
      return cached_album
    end
  end

  return nil
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

