
def ask_for_album_data(text, album)
  puts text
  print "Enter date (#{album.date}): "
  date = STDIN.gets.chomp
  if date != ''
    album.date = date
  end
  print "Enter artist (#{album.artist}): "
  artist = STDIN.gets.chomp
  if artist != ''
    album.artist = artist
  end
  print "Enter title (#{album.title}): "
  title = STDIN.gets.chomp
  if title != ''
    album.title = title
  end
  return album
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
  print "Enter option (#{default}) (X to cancel): "
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
