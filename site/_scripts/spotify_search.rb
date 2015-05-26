
require 'yaml'
require_relative 'SpotifySearch'

def update_file(file_name)
  data = YAML.load_file(file_name)

  process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
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

    spotify_data = SpotifySearch.get_spotify_data(album['title'], album['artist'], album['type'])
    if spotify_data
      album['spotify'] = spotify_data
    end
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

