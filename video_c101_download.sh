#!/bin/bash
destdir="data/video_c101"
mkdir -p "$destdir"
grep -h -E -o 'http://www.channel101.com/s/videos/[a-z0-9]+\.m4v' data/episode_description/*.html \
| while read url; do
	dest="$destdir/${url##*/}"
	[ -e "$dest" ] || wget -O "$dest" "$url"
done
