#!/bin/sh
#Nubango Radio Tuner Service
if [ $(id -u) -eq 0 ] ; then
	echo "DO NOT RUN NUBANGO AS ADMINISTRATOR!"
	echo "Here be dragons. Exiting..."
	exit 125
fi
# XML_MAP is a map of "magic number" IDs to filenames.
XML_MAP="AppleApp1 nubango-auth
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
XML_ID=$(echo "$QUERY_STRING" | sed -En "s/.*tuning_id=(-?[[:digit:]]+[[:digit:]]?).*/\1/p; s/username=(AppleApp1)/\1/p")
# Search XML_MAP for a string (file name) using the parsed ID.
XML_FILE=$(echo "$XML_MAP" | sed -En "s/^$XML_ID\ ([[:alnum:]-]+)$/\1/p")
if [ -z "$XML_FILE" ] ; then
	echo "Status: 404 Not Found
Content-Type: text/plain
"
	echo "404 Not Found"
else
	echo "Status: 200 OK
Content-Type: application/xml
"
	cat "$DOCUMENT_ROOT/xml/$XML_FILE.xml"
fi
