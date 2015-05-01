
require 'yaml'
require 'json'
require 'uri'

#config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
#$app_config = YAML.load_file(config_path)

def copy_file(file_name, existing_data)
  data = YAML.load_file(file_name)

  new_data = process_data(data)

  existing_data.concat(new_data)

  #file = File.open(new_file_name, 'w')
  #file.puts new_data.to_yaml
  #file.close
end

def process_data(data)
  new_data = []
  data.each do |album|
    # Actually just going to ignore everything with no date.
    if (album['date'] == '')
      next
    end
    new_album = {}
    new_album['date'] = Date.parse(album['date'])
    new_album['title'] = album['title'].strip()
    new_album['artist'] = album['artist'].strip()
    #new_album['review'] = album['review']
    review = URI(album['review'])
    if (review.path.split('/')[1] == 'web')
      # indicates this has the Archive.org bits in it
      review = URI(review.path.split('/')[3..-1].join('/'))
    end
    if (review.host == nil)
      review.host = "www.bbc.co.uk"
    end
    if (review.scheme == nil)
      review.scheme = "http"
    end
    new_album['review'] = review.to_s

    new_data.push(new_album)
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
data = []
for arg in ARGV
  copy_file(arg, data)
end

puts data.size
data = dedup(data)
puts data.size

puts data.to_yaml
