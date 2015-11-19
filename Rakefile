years = [2009,2010,2011,2012,2013,2014,2015]

# Default task: all years, then jekyll.
task :default => years.map{|year| "year#{year}"} + [:jekyll]

# Each year has a task to build the year called "yearXXXX"
# and another to build the year AND the Jekyll site, for use
# on the command line.
years.each do |year|
  task "year#{year}" do
    Dir.chdir('site') do
      file = "_data/year/#{year}.yml"
      puts " === Building #{year} === "
      ruby "_scripts/twitpic.rb #{file}"
      ruby "_scripts/spotify_search.rb #{file}"
      ruby "_scripts/spotify_cover.rb #{file}"
      ruby "_scripts/reorder.rb #{file}"
    end
  end

  task "#{year}" => ["year#{year}", :jekyll]
end

task :jekyll do
  Dir.chdir('site') do
    sh "jekyll build"
  end
end
