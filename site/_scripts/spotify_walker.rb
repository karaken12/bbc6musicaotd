
require 'yaml'
require_relative '_questions'

def update_file(file_name)
  data = YAML.load_file(file_name)

  data = process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_data(data)
  data.each do |album|
    if album.has_key?('spotify-id')
      # Assume it's fine
      next
    end
    puts "==="
    if !album.has_key?('spotify')
      puts "No Spotify data for #{album['date']}."
      next
    end
    if !album['spotify'].has_key?('candidates')
      puts "No candidates for #{album['date']}."
      next
    end
    candidates = album['spotify']['candidates']
    selected_id = nil
    if album['spotify'].has_key?('selected')
      selected_id = album['spotify']['selected']['album_id']
    end
    puts "#{album['title']} by #{album['artist']}"
    if album.has_key?('notes')
      puts "(#{album['notes']})"
    end

    chosen_index = choose_candidates(candidates, selected_id)
    if chosen_index == nil then next end
    
    album['spotify-id'] = candidates[chosen_index]['album_id']
    album.delete('spotify')
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

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

