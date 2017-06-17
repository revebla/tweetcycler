#!/usr/bin/env bash
TWITTERUSER="revebla"
CURRENT="$(date -Ins)"
DAYLIMIT="10"
getLatestTweets(){
	t timeline $TWITTERUSER -c 
}

let i 0
for item in $(getLatestTweets | cut -d, -f1,2 | tail -n+2 | sed -e "s/ /€/g"); do
	tweet[$i]="${item/+0000/}"
	(( i += 1 ))
done

for item in ${tweet[*]}; do 
	PAST=$(echo ${item//€/ } | cut -d, -f2)
	TWEETID=$(echo ${item//€/ } | cut -d, -f1)
	if ! grep -q ${item/,*/} excludedTweets ; then
		DAYS=$(bc -l <<< "( `date -d $CURRENT +%s` - `date -d ${PAST/ /T} +%s`) / (24*3600)" )
		if [ "${DAYS/.*/}" -ge "$DAYLIMIT" ]; then
			t delete status $TWEETID -f
		fi
	fi
done
