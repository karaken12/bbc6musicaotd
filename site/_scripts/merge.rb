
require 'yaml'

def merge_files(file_name_1, file_name_2)
  data_1 = YAML.load_file(file_name_1)
  data_2 = YAML.load_file(file_name_2)

  new_data = merge_data(data_1, data_2)
  # Sort by reverse date
  new_data.sort!{|a,b| b['date'] <=> a['date']}
  
  file = File.open(file_name_1, 'w')
  file.puts new_data.to_yaml
  file.close
end

def merge_data(data_1, data_2)
  new_data = []
  added = 0
  total_merged = 0
  data_1.each{|album| new_data.push(album)}
  data_2.each do |album|
    index = new_data.find_index{|a| a['date'] == album['date']}
    if index == nil
      new_data.push(album)
      added+=1
    else
      merged = merge_albums(new_data[index], album)
      if merged == nil
        puts "Dup found! #{album['date']}"
        # Add as a new, separate album
        new_data.push(album)
        added+=1
      else
        new_data.delete_at(index)
        new_data.push(merged)
        total_merged+=1
      end
    end
  end

  puts "Added #{added}, merged #{total_merged}."
  return new_data
end

def merge_albums(album_1, album_2)
  new_album = {}
  album_1.each{ |key,value| new_album[key] = value }
  album_2.each do |key,value|
    if new_album.include?(key)
      if (new_album[key] != value)
        return nil
      end
    end
    # If it 
    new_album[key] = value
  end
  
  return new_album
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
  merge_files(ARGV[0], ARGV[1])
end
