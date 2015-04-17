
require 'twitter'
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
  outdata = []
  urls_seen = []
  data.each do |album|
    if !album.has_key?('twitter')
      outdata.push(album)
      next
    end
    if !urls_seen.include?(album['twitter'])
      urls_seen.push(album['twitter'])
      outdata.push(album)
    end
  end
  return outdata
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

