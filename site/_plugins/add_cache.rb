module JekyllBbc6musicaotd
  class AddCache < Jekyll::Generator
    def generate(site)
      site.data['year'].values.each do |year|
        year.each do |album|
          if album.has_key?('twitter')
            album['tweet'] = site.data['cache']['twitter'][album['twitter']]
          end
        end
      end
    end
  end
end
