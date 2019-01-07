#!/bin/bash
destdir="data/show_description"
mkdir -p "$destdir"
grep -h -E -o '"/show/[0-9]+"' data/screenings/*.html \
| grep -E -o '[0-9]+' \
| while read num; do
	dest="$destdir/${num}.html"
	url="http://www.channel101.com/show/${num}"
	[ -e "$dest" ] || wget -O "$dest" "$url"
done
