module JekyllBbc6musicaotd
  class SortByDate < Jekyll::Generator
    def generate(site)
      site.data['year'].values.each do |year|
        year.sort!{|a,b| a['date'] <=> b['date']}
      end
    end
  end
end
