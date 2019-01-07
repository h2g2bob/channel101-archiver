#!/bin/bash
destdir="data/screenings"
mkdir -p "$destdir"
for ((num=1; num <= 245; num++)); do
	out="$destdir/${num}.html"
	[ -e "$out" ] || wget -O "$out" "http://www.channel101.com/shows-content/$num"
done
