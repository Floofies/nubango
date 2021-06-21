#!/bin/sh
#Nubango Radio Tuner Service
if (( $EUID == 0 )); then
	echo "DO NOT RUN NUBANGO AS ADMINISTRATOR!"
	echo "Here be dragons. Exiting..."
	exit 125
fi
# XML_MAP is a map of "magic number" IDs to filenames.
XML_MAP="username=AppleApp1 nubango-auth
129 golden-oldies
141 classical
102 international-world
103 eclectic
112 jazz
120 reggae-island
163 ambient
21 news-talk-radio
24 top-40-pop
35 religious
36 hip-hop-rap
48 hard-rock-metal
86 college-university
11 comedy
12 blues
14 alternative-rock
18 classic-rock
19 sports-radio
20 rnb-soul
3 90s-hits
4 70s-retro
5 80s-flashback
7 electronica
8 country
9 adult-contemporary
1 genres
-12 genres"
# Parse querystring Tuning ID or username.
XML_ID=$(echo $QUERY_STRING | sed -rn "s/tuning_id\=(\-?[[:digit]]+|[[:digit:]]+)|(username=AppleApp1)/\1/p")
# Search XML_MAP for a string (file name) using the parsed ID.
XML_FILE=$(echo $XML_MAP | grep "$XML_ID" | sed -rn "s/^$XML_ID ([[:alpha:]]+)/\1/p")
if echo XML_FILE | sed -rn '/[[:alpha:]]+/!{q1}'; then
	echo "Content-Type: text/xml
"
	cat "$DOCUMENT_ROOT/xml/$XML_FILE.xml"
else
	echo "Content-Type: text/plain
HTTP 1.1/ 404"
fi
