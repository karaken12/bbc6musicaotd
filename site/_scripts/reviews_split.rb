
require 'yaml'

#config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
#$app_config = YAML.load_file(config_path)

def extract_year(file_name, year)
  data = YAML.load_file(file_name)

  new_data = process_data(data, year)
  # Sort by reverse date
  new_data.sort!{|a,b| b['date'] <=> a['date']}

  puts new_data.to_yaml

  #file = File.open(new_file_name, 'w')
  #file.puts new_data.to_yaml
  #file.close
end

def process_data(data, year)
  new_data = []
  data.each do |album|
    # Actually just going to ignore everything with no date.
    if (album['date'] == '')
      next
    end
    if album['date'].year == year
      new_data.push(album)
    end
  end
  return new_data
end

def dedup(data)
  new_data = []
  for album in data
    if new_data.find_index(album) == nil
      new_data.push(album)
    elsif new_data.find_index{|a| a != album and a['date'] == album['date']} != nil
      puts "Duplicate date: #{album['date']}!"
      index = new_data.find_index{|a| a['date'] == album['date']}
      puts "Overall: #{new_data[index] == album}"
      puts "Dates: #{new_data[index]['date'] == album['date']}"
      puts "Titles: #{new_data[index]['title'] == album['title']}"
      puts "Artists: #{new_data[index]['artist'] == album['artist']}"
      puts "Reviews: #{new_data[index]['review'] == album['review']}"
      new_data.push(album)
    end
  end
  return new_data
end

# Bit nasty, but should do the job
if ARGV.size >= 2
  extract_year(ARGV[0], ARGV[1].to_i)
end
