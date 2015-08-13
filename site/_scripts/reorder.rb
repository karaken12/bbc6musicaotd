#!/usr/bin/env ruby

require 'yaml'

def update_file(file_name)
  data = YAML.load_file(file_name)

  data = process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_album(album)
  new_album = {}
  keys = ['date','artist','title','type','notes','twitter','tweet','review','spotify-id', 'spotify']
  keys.each do |key|
    if album[key]
      new_album[key] = album[key]
    end
  end
  outstanding_keys = album.keys - keys
  puts outstanding_keys
  outstanding_keys.each do |key|
    new_album[key] = album[key]
  end
  return new_album
end

def process_data(data)
  new_data = [] 
  data.sort{|a,b| a['date'] <=> b['date']}.each do |album|
    new_album = process_album(album)
    new_data.push(new_album)
  end
  return new_data
end

# Bit nasty, but should do the job
if ARGV
  ARGV.each do |file|
    update_file(file)
  end
end

