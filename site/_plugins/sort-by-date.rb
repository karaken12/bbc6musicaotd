module JekyllBbc6musicaotd
  class SortByDate < Jekyll::Generator
    def monday(date)
      # Modulus idea from Phrogz on SO; not really nescessary but keeps us safe.
      date - (date.wday - 1)%7
    end

    def generate(site)
      site.data['year'].values.each do |year|
        year.sort!{|a,b| a['date'] <=> b['date']}
        year.each do |album|
          album['week'] = monday(album['date'])
        end
      end
      this_year = '2016'
      this_year_albums = site.data['year'][this_year]
      site.data['recent'] = this_year_albums.select{|album| album['artist'] && album['title']}.reverse[0,5]
    end
  end
end
