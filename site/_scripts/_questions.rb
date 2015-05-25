
def ask_for_twitter_data(tweet, album)
  return_data = {'artist' => album['artist'], 'title' => album['title']}
  puts "Twitter: #{tweet['text']}"
  print "Enter artist (#{album['artist']}): "
  artist = STDIN.gets.chomp
  if artist != ''
    return_data['artist'] = artist
  end
  print "Enter title (#{album['title']}): "
  title = STDIN.gets.chomp
  if title != ''
    return_data['title'] = title
  end
  return return_data
end

