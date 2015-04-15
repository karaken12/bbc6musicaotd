
require 'rspotify'
require 'yaml'

config_path = File.expand_path('app_secret.yml', File.dirname(__FILE__))
$app_config = YAML.load_file(config_path)

def update_file(file_name)
  data = YAML.load_file(file_name)

  process_data(data)

  file = File.open(file_name, 'w')
  file.puts data.to_yaml
  file.close
end

def process_data(data)
  data.each do |album|
    if (album['spotify']) then next end
    if !album['title']
      puts "= Title missing for item on #{album['date']}"
      next
    end
    if !album['artist']
      puts "= Artist missing for item on #{album['date']}"
      next
    end

    search_string = "album:\"#{album['title']}\""
    search_string += "+artist:\"#{album['artist']}\""

    spotify_albums = RSpotify::Album.search(search_string, market: 'GB')

    spotify_albums_sel = spotify_albums.select{|sa| sa.album_type == 'album'}

    puts "- Search for #{album['title']} by #{album['artist']}"
    puts "  Found #{spotify_albums.total} (#{spotify_albums_sel.count} selected)"

    if (spotify_albums_sel.count == 1)
      album['spotify'] = {'album_id' => spotify_albums_sel[0].id}
    else
      if (spotify_albums_sel.count != 0)
        #puts "  Candidate titles: " + spotify_albums_sel.map{|sa| "#{sa.name} (#{sa.id})"}.join(", ")
        candidates = []
        spotify_albums_sel.each{|sa| candidates.push({'name'=>sa.name, 'album_id'=>sa.id})}
        album['spotify'] = {'candidates' => candidates}
      end
      #puts "  Search at: https://api.spotify.com/v1/search?q=#{search_string}&type=album&market=GB"
    end
  end
end

# Bit nasty, but should do the job
if (ARGV[0])
  update_file(ARGV[0])
end

