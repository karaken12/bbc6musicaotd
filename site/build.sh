
for f in _data/year/*${1}.yml
do
  echo " === Building $f === "
  ruby _scripts/twitpic.rb $f
  ruby _scripts/spotify_search.rb $f
  ruby _scripts/spotify_cover.rb $f
  ruby _scripts/reorder.rb $f
done
jekyll build
