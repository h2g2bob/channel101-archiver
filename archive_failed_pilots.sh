#!/bin/bash
set -o nounset
set -o errexit

year="$1"
sentinal="data/upload-sentinal/failed-pilots-${year}"
ident="channel101-failed-pilots-${year}"
collectiondir="data/failed-pilot/${year}"
descriptionfile="$(pwd)/data/failed-pilot-${year}.txt"

[ -e "${sentinal}" ] && {
	echo already uploaded
	exit 1
}

./download_failed_pilots.sh "$year"

( cd "${collectiondir}" && ia upload "${ident}" "./" \
	--delete \
	--metadata="title:Channel 101 failed pilots ${year}" \
	--metadata="creator:Channel101" \
	--metadata="description:Failed pilots submitted to Channel101 in $year<br /><br />$(< "$descriptionfile" )" \
	--metadata="date:${year}" \
	--metadata="subject:channel101" \
	--metadata="mediatype:movies" \
	--metadata="collection:opensource_movies" )

touch "${sentinal}"
