module JekyllBbc6musicaotd
  class SortByDate < Jekyll::Generator
    def generate(site)
      site.data['2014'].sort!{|a,b| a['date'] <=> b['date']}
      site.data['2015'].sort!{|a,b| a['date'] <=> b['date']}
    end
  end
end
