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
  keys = ['date','artist','title','type','notes','spotify-id','sources']
  keys.each do |key|
    if album[key]
      new_album[key] = album[key]
    end
  end
  outstanding_keys = album.keys - keys
  # Process known old keys
  process_old_key('twitter', album, new_album, outstanding_keys)
  process_old_key('facebook', album, new_album, outstanding_keys)
  process_old_key('review', album, new_album, outstanding_keys)
  # Display and keep any still remaining keys
  puts outstanding_keys
  outstanding_keys.each do |key|
    new_album[key] = album[key]
  end
  # Order and de-dup sources
  if new_album.has_key?('sources')
    new_album['sources'] = process_sources(new_album['sources'])
  end
  return new_album
end

def process_old_key(key_name, album, new_album, outstanding_keys)
  if outstanding_keys.include?(key_name)
    if !new_album.has_key?('sources')
      new_album['sources'] = {}
    end
    if !new_album['sources'].has_key?(key_name)
      new_album['sources'][key_name] = []
    end
    new_album['sources'][key_name].unshift(album[key_name])
    outstanding_keys.delete(key_name)
  end
end

def process_sources(sources)
  new_sources = {}
  keys = ['twitter', 'facebook', 'review']
  keys.each do |key|
    if sources[key]
      new_sources[key] = []
      if sources[key].kind_of?(Array)
        sources[key].each do |src|
          if !new_sources[key].include?(src)
            new_sources[key].push(src)
          end
        end
      else
        new_sources[key] = [ sources[key] ]
      end
    end
  end
  outstanding_keys = sources.keys - keys
  if outstanding_keys.size() > 0
    puts "Unknown sources: #{outstanding_keys}"
    outstanding_keys.each do |key|
      new_sources[key] = sources[key]
    end
  end
  return new_sources
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

