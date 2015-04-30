
A bit of code to get data out of
http://web.archive.org/web/20130401001737/http://www.bbc.co.uk/music/reviews/recommenders/9v3c

```
reviews=[]; $('.review').each(function(){ reviews[reviews.length] = {'date': $(this).find('.date').text(), 'artist': $(this).find('.artist_name').text().trim(), 'title': $(this).find('.title').text().trim(), 'review': $(this).find('.title > a').attr('href') };}); copy(reviews);
```

For the earlier site, this should be:

```
reviews=[]; $('.review').each(function(){ reviews[reviews.length] = {'date': $(this).find('.date').text(), 'artist': $(this).find('.release').clone().children('span').remove().end().text().trim(), 'title': $(this).find('.title > a').text().trim(), 'review': $(this).find('.title > a').attr('href') };}); copy(reviews);
```
