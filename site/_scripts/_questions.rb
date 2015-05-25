
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

def choose_candidates(candidates, selected_id)
  puts "#{candidates.size} candidates:"
  default = ""
  candidates.each_with_index do |candidate, index|
    title = candidate['name']
    type = candidate['type']
    id = candidate['album_id']
    artist = candidate['artists'].join(', ')
    if id == selected_id
      ast = "*"
      default = index.to_s()
    else
      ast = " "
    end
    puts "#{ast}#{index}: #{title} by #{artist} (#{type}, #{id})"
  end
  print "Enter option (#{default}): "
  chosen = STDIN.gets.chomp
  if chosen == nil or chosen.strip() == ''
    chosen = default
  end
  if chosen == nil or chosen.strip() == ''
    return nil
  end
  begin
    chosen_index = Integer(chosen)
  rescue ArgumentError
    return nil
  end
  return chosen_index
end
