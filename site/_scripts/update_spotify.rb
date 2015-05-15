
require 'yaml'
CACHE_FILE_NAME = "_data/cache/spotify.yml"

def update_file(file_name)
  data = YAML.load_file(file_name)
  if File.exist?(CACHE_FILE_NAME)
    cache = YAML.load_file(CACHE_FILE_NAME)
  else
    cache = {}
  end

  process_data(cache, data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close

  file = File.open(CACHE_FILE_NAME, 'w')
  file.puts cache.to_yaml
  file.close
end

def process_data(cache, data)
  data.each do |album|
    if !album.has_key?('spotify') or !album['spotify'].has_key?('album_id') then
      next
    end

    album_id = album['spotify']['album_id']
    cache[album_id] = album['spotify']
    album['spotify-id'] = album_id
    album.delete('spotify')
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

