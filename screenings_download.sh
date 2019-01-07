for ((num=1; num <= 245; num++)); do
	out="data/screenings/${num}.html"
	[ -e "$out" ] || wget -O "$out" "http://www.channel101.com/shows-content/$num"
done
