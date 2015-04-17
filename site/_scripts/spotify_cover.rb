
require 'rspotify'
require 'yaml'

config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
$app_config = YAML.load_file(config_path)

def update_file(file_name)
  data = YAML.load_file(file_name)

  data = process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_data(data)
  data.each do |album|
    if !album['spotify'] then next end
    if !album['spotify']['album_id'] then next end
    if album['spotify']['images'] then next end

    puts "Getting images for #{album['title']}."
    spotify_album = RSpotify::Album.find(album['spotify']['album_id'])
    
    album['spotify']['images'] = spotify_album.images
  end
  return data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

