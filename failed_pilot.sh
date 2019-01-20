#!/bin/bash
set -o nounset
set -o errexit

year=$1

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

descriptionfile="data/failed-pilot-${year}.txt"
echo -n > "${descriptionfile}"

htmldir="data/failed-pilot-descriptions"
mkdir -p "${htmldir}"

collectiondir="data/failed-pilot/${year}"
mkdir -p "${collectiondir}"

grep -hEo '"/episode/[0-9]+"' data/screenings/*.html \
| grep -E -o '[0-9]+' \
| while read num; do
	htmlfile="${htmldir}/${num}.html"
	linkurl="http://www.channel101.com/episode/${num}"
	download "${htmlfile}" "${linkurl}"

	if grep -F "<div id='status' class='badge'>Failed Pilot</div>" "${htmlfile}" > /dev/null; then
		date=$( cat "${htmlfile}" | sed -nre "s/^.*<span id='episodeScreening'.*>([A-Za-z]+ [0-9]+, [0-9]{4})<\/a><\/span>$/\1/p" )
		if [ "${date##* }" = "${year}" ]; then

			echo "$year: $htmlfile"

			name="$( cat "${htmlfile}" \
				| sed -nre "s/^.*<div id='showTitle' class='metaArea'>(.*)<\/div>.*$/\1/p" \
				)"
			[ -z "${name}" ] && exit 1

			videourl="$( cat "${htmlfile}" \
				| sed -nre "s/^.*file: '(http:\/\/www.channel101.com\/s\/videos\/[a-z0-9]+\.(mp4|m4v))',$/\1/p" \
				)"
			[ -z "${videourl}" ] && exit 1

			ident="$(
				echo "${name}" \
				| tr '[:upper:]' '[:lower:]' \
				| tr -s -c '[:alnum:]' '-' \
				| sed -r -e 's/^[-]|[-]$//g' \
				)"
			[ -z "${ident}" ] && exit 1

			description="$( cat "${htmlfile}" \
				| sed -r -n -e 's/^.*<meta name="description" content="([^"]+)".*$/\1/p' \
				)"
			[ -z "${description}" ] && exit 1

			echo "${year} ${date} ${ident} ${videourl}"
			cp "${htmlfile}" "${collectiondir}/${ident}.html"
			download "${collectiondir}/${ident}.${videourl##*.}" "${videourl}"

			echo "${name} (${date})<br/>" >> "${descriptionfile}"
			echo "<a href=\"${linkurl}\">${linkurl}</a><br/>" >> "${descriptionfile}"
			echo "${description}<br/>" >> "${descriptionfile}"
			echo "<br/>" >> "${descriptionfile}"

		fi
	fi
done

cat "${descriptionfile}"



