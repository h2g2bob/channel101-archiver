#!/bin/bash
destdir="data/episode_thumb"
mkdir -p "$destdir"
grep -h -E -o 'http://www.channel101.com/image-cache/200/113/95/images/episode/[a-z0-9]+\.jpg' data/screenings/*.html \
| while read url; do
	dest="$destdir/${url##*/}"
	[ -e "$dest" ] || wget -O "$dest" "$url"
done
