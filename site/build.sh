
for f in _data/year/*${1}.yml
do
  ./year-build.sh $f
done
jekyll build
