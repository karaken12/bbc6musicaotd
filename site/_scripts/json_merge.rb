
require 'yaml'
require 'json'
require 'uri'

#config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
#$app_config = YAML.load_file(config_path)

def copy_file(file_name, new_file_name)
  data = YAML.load_file(file_name)

  new_data = process_data(data)

  puts new_data.to_yaml

  #file = File.open(new_file_name, 'w')
  #file.puts new_data.to_yaml
  #file.close
end

def process_data(data)
  new_data = []
  data.each do |album|
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

# Bit nasty, but should do the job
if (ARGV[0] and ARGV[1])
  copy_file(ARGV[0], ARGV[1])
end

