This is a set of hacky scripts for archiving all the videos from channel101.com

# Why

[Channel101](http://www.channel101.com/) is a monthly film festival, featuring
a selection of 5 minute films. The films are of variable qualiry: some are
[great](http://www.channel101.com/show/96), others
[not so much](http://www.channel101.com/show/166) and some in
[questionable taste](http://www.channel101.com/show/214).

So why bother to back it up? Well, it's culturally important: it's where _SNL_
writing trio _The Lonely Island_ started; and where _Adult Swim_ show
_Rick and Morty_ began.

I suspect it's also run (and funded) by a small number of busy people. What
would happen if the server exploded, or the wrong person left, or if
[someone tried to sue](https://en.wikipedia.org/wiki/House_of_Cosbys)? The
community would probably survive, but the history might be lost.

# How

Get a list of screenings:

```
./screenings_download.sh
```

In here is a lot of useful `/show/<num>` links.

Downloading videos:

```
./download_show.sh 123
```

Uploading videos:

```
./archive_show.sh 123
```

If something goes wrong, you can safely run the script again.

The scripts are written very poorly, on the expectation they'll only get run once.

# What's on the website?

About 200G of videos.

## Shows

There are about 221 active and cancelled shows (each of which have several episodes). Approximate number of episodes per show:

```
for file in data/show_description/*.html; do grep -E -o 'Episode [0-9]+' "$file" | sort | tail -n 1; done | sort | uniq -c
      1 Episode 1
     89 Episode 2
     38 Episode 3
     24 Episode 4
     25 Episode 5
     15 Episode 6
      4 Episode 7
      8 Episode 8
     17 Episode 9

```

## Failed pilots

In additon, there are 483 shows with a single episode each. Channel 101 calls them pilots because they were rejected at the first screening:

```
grep -lF 'Failed Pilot' data/episode_description/*.html | xargs grep -F "<span id='episodeScreening'" | grep -E -o '20[0-9]{2}'| sort | uniq -c
     23 2003
     32 2004
     40 2005
     29 2006
     31 2007
     31 2008
     29 2009
     30 2010
     35 2011
     39 2012
     32 2013
     30 2014
     32 2015
     23 2016
     29 2017
     18 2018
```

## Rejects

Pilots which didn't get screened are NOT included on the site, even though [rejectee therapy](http://www.channel101.com/therapy) is available.
