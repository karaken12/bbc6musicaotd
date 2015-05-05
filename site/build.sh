
for f in _data/year/*.yml
do
  ./year-build.sh $f
done
jekyll build
