module JekyllBbc6musicaotd
  class AddCache < Jekyll::Generator
    def generate(site)
      site.data['year'].values.each do |year|
        year.each do |album|
          if album.has_key?('twitter')
            album['tweet'] = site.data['cache']['twitter'][album['twitter']]
          elsif album.has_key?('sources') && album['sources'].has_key?('twitter') && album['sources']['twitter'].length > 0
            album['tweet'] = site.data['cache']['twitter'][album['sources']['twitter'][0]]
          end
          if album.has_key?('spotify-id')
            album['spotify'] = site.data['cache']['spotify'][album['spotify-id']]
          end
        end
      end
    end
  end
end
