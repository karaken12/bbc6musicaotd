
require 'yaml'
require_relative 'SpotifySearch'

CANDIDATE_FILE_NAME = "_data/cache/spotify_candidates.yml"

def update_file(file_name)
  data = YAML.load_file(file_name)

  candidates = process_data(data)

  candidate_data = YAML.load_file(CANDIDATE_FILE_NAME)
  if !candidate_data || candidate_data == ''
    candidate_data = {}
  end
  candidate_data[file_name] = candidates

  file = File.open(CANDIDATE_FILE_NAME, 'w')
  file.puts candidate_data.to_yaml
  file.close
end

def process_data(data)
  candidate_data = []

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
      candidate_data.push(album)
    end
  end

  return candidate_data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

