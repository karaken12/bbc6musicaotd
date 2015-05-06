
require 'yaml'

def update_file(file_name)
  data = YAML.load_file(file_name)

  data = process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_album(album)
  tweet_data = {}
  tweet_data['id'] = album['twitter']
  album.delete('twitter')
  if album['tweet_text']
    tweet_data['text'] = album['tweet_text']
    album.delete('tweet_text')
  end
  if album['twitpic']
    tweet_data['media'] = {'url' => album['twitpic']}
    album.delete('twitpic')
  end
  album['tweet'] = tweet_data
  return album
end

def process_data(data)
  new_data = [] 
  data.each do |album|
    new_album = album
    if !album.has_key?('twitter') then
      new_data.push(album)
      next
    end
    if album['twitter'] == '' or album['twitter'].nil? then
      album.delete('twitter')
      new_data.push(album)
      next
    end
    if !album['tweet']
      new_album = process_album(album)
    end
    new_data.push(new_album)
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

