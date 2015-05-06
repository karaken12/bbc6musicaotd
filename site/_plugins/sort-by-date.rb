module JekyllBbc6musicaotd
  class SortByDate < Jekyll::Generator
    def generate(site)
      site.data['year'].values.each do |year|
        year.sort!{|a,b| a['date'] <=> b['date']}
      end
      this_year = '2015'
      this_year_albums = site.data['year'][this_year]
      site.data['recent'] = this_year_albums.reverse[0,5]
    end
  end
end
