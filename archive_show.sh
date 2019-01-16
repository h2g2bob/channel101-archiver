#!/bin/bash
set -o nounset
set -o errexit

shownum="$1"
destdir="data/show/${shownum}"
sentinal="data/upload-sentinal/${shownum}"

[ -e "${sentinal}" ] && {
	echo already uploaded
	exit 1
}

name=$(cat "${destdir}/show.html" \
	| sed -r -n -e "s/^.*<div id='showTitle' class='metaArea'>(.*)<\/div>.*$/\1/p" )
description=$(cat "${destdir}/show.html" \
	| sed -r -n -e 's/^.*<meta name="description" content="([^"]+)".*$/\1/p' )
year=$(cat "${destdir}/ep_1.html" \
	| sed -r -n -e "s/^.*<span id='episodeScreening' class='metaArea'.*><a .*>.*, ([0-9]{4})<\/a><\/span>.*$/\1/p" )

linkurl="http://www.channel101.com/show/${shownum}"

ident="channel101-$(
	echo "${name}" \
	| tr '[:upper:]' '[:lower:]' \
	| tr -s -c '[:alnum:]' '-' \
	| sed -r -e 's/^[-]|[-]$//g' \
	)"

( cd "${destdir}" && ia upload "${ident}" "./" \
	--delete \
	--metadata="title:Channel 101: ${name}" \
	--metadata="description:${name} from Channel101<br />Copied from ${linkurl}<br /><br />Description from the website:<br />${description}" \
	--metadata="date:${year}" \
	--metadata="source:${linkurl}" \
	--metadata="subject:channel101" \
	--metadata="mediatype:movies" \
	--metadata="collection:opensource_movies" )

touch "${sentinal}"
