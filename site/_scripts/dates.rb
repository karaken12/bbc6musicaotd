
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
  dates = {}
  dates.default = 0
  data.each do |album|
    if !album.has_key?('date') then next end
    album['date'] = Date.parse(album['date'].to_s)
    dates[album['date']] += 1
  end
  dates.each do |date, instances|
    if instances > 1
      puts "#{date} has #{instances} occurances."
    end
  end
  return data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

