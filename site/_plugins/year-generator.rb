module Aotd
  class Year < Jekyll::Page
    def initialize(site, base, dir, year, data)
      @site = site
      @base = base
      @dir = year
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'year.html')

      self.data['albums'] = data
    end
  end

  class Generator < Jekyll::Generator
    def generate(site)
      # Set dir so we save at the top level.
      dir = ''
      site.data['year'].each do |year, data|
        site.pages << Year.new(site, site.source, dir, year, data)
      end
    end
  end
end
