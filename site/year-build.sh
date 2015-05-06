echo " === Building $1 === "
ruby _scripts/twitpic.rb $1
ruby _scripts/spotify_search.rb $1
ruby _scripts/spotify_cover.rb $1
ruby _scripts/reorder.rb $1
