
require 'yaml'

def update_file(file_name)
  data = YAML.load_file(file_name)

  data = process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_data(data)
  data.each do |album|
    if album.has_key?('spotify')
      # Assume it's fine
      next
    end
    puts "==="
    if !album.has_key?('tweet_text')
      puts "No tweet text on #{album['date']}."
      next
    end
    puts "Twitter: #{album['tweet_text']}"
    print "Enter artist (#{album['artist']}): "
    artist = STDIN.gets.chomp
    if artist != ''
      album['artist'] = artist
    end
    print "Enter title (#{album['title']}): "
    title = STDIN.gets.chomp
    if title != ''
      album['title'] = title
    end
  end
  return data
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

