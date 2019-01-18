#!/bin/bash
set -o nounset
set -o errexit

function download() {
	dest="$1"
	url="$2"
	echo "Saving $url to $dest"
	[ -s "$dest" ] || {
		wget --quiet -O "$dest-part" "$url"
		mv "$dest-part" "$dest"
	}
}

function warn() {
	echo -e "WARN: \x1b[31m$*\x1b[0m"
}

shownum="$1"
destdir="data/show/${shownum}"
sentinal="data/upload-sentinal/${shownum}"

[ -e "${sentinal}" ] && {
	echo already uploaded
	exit 1
}

if [ -e "blacklist/${shownum}_all" ]; then
	warn "Skipping show because blacklist/${shownum}_all"
	exit 1
fi

mkdir -p "$destdir"

show_description="$destdir/show.html"
download "${show_description}" "http://www.channel101.com/show/${shownum}"

main_thumb_url=$( grep -h -E -o 'http://www.channel101.com/image-cache/540/304/100/images/series/.*\.(jpg|jpeg|png)' "${show_description}" | head -n 1 )
download "${destdir}/cover.${main_thumb_url##*.}" "${main_thumb_url}"

episodenum=$( cat "${show_description}" \
	| grep -h -E -o '"/episode/[0-9]+"' \
	| uniq \
	| wc -l )
cat "${show_description}" \
| grep -h -E -o '"/episode/[0-9]+"' \
| uniq \
| grep -E -o '[0-9]+' \
| while read episodecode; do
	episode_description="${destdir}/ep_${episodenum}.html"
	download "${episode_description}" "http://www.channel101.com/episode/${episodecode}"

	thumb_url="$( grep -h -E -o 'http://www.channel101.com/image-cache/200/113/95/images/episode/[a-z0-9]+\.jpg' "${episode_description}" | head -n 1 )"
	if [ -z "${thumb_url}" ]; then
		thumb_url="$( grep -h -E -o 'http://www.channel101.com/image-cache/640/360/100/images/episode/[a-z0-9]+\.png' "${episode_description}" | head -n 1 )"
	fi

	episode_thumb="$destdir/ep_${episodenum}.${thumb_url##*.}"
	if [ -z "${thumb_url}" ]; then
		warn "No thumbnail found";
	else
		download "${episode_thumb}" "${thumb_url}"
	fi

	if [ -e "blacklist/${shownum}_${episodenum}" ]; then
		warn "Skipping video because blacklist/${shownum}_${episodenum}"
	else
		video_url="$( grep -h -E -o 'http://www.channel101.com/s/videos/[a-z0-9]+\.(m4v|mp4)' "${episode_description}" | head -n 1 )"
		episode_video="$destdir/ep_${episodenum}.${video_url##*.}"
		download "${episode_video}" "${video_url}"
	fi

	episodenum=$(( ${episodenum} - 1 ))
done
