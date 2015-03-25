
require 'twitter'
require 'yaml'

def update_file(file_name)
  client = Twitter::REST::Client.new do |config|
    config.consumer_key = 'zCIQNgdHnwErHzhMORlFCNMdD'
    config.consumer_secret = 'YjDEcFlFfXIfp2GUTNjPR3YbuFDjiwYbRfqyZWEbTHLFri3WNI'
  end

  data = YAML.load_file(file_name)

  data.each do |album|
    if (album['twitpic'] or !album['twitter'])
      next
    end
    puts album['twitter']
    tweet = client.status(album['twitter'])
    if tweet and tweet.media?
#      photo = tweet.media[0]
#      puts photo.media_url
#      puts photo.sizes
#      puts photo.sizes[:thumb]
      album['twitpic'] = tweet.media[0].media_url.to_s()
    end
  end
  
  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

