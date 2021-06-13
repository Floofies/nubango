#!/bin/sh
#Nubango Radio Tuner Service
if (( $EUID == 0 )); then
	echo "DO NOT RUN NUBANGO AS ADMINISTRATOR!"
	echo "Here be dragons. Exiting..."
	exit 125
fi
echo "Content-type: text/xml
"
if echo $QUERY_STRING | grep -q "tuning_id=-12" ; then
	cat $DOCUMENT_ROOT/xml/genres.xml
elif echo $QUERY_STRING | grep -q "username=AppleApp1" ; then
	cat $DOCUMENT_ROOT/xml/nubango-auth.xml
elif echo $QUERY_STRING | grep -q "tuning_id=129" ; then
	cat $DOCUMENT_ROOT/xml/golden-oldies.xml
elif echo $QUERY_STRING | grep -q "tuning_id=141" ; then
	cat $DOCUMENT_ROOT/xml/classical.xml
elif echo $QUERY_STRING | grep -q "tuning_id=102" ; then
	cat $DOCUMENT_ROOT/xml/international-world.xml
elif echo $QUERY_STRING | grep -q "tuning_id=103" ; then
	cat $DOCUMENT_ROOT/xml/eclectic.xml
elif echo $QUERY_STRING | grep -q "tuning_id=112" ; then
	cat $DOCUMENT_ROOT/xml/jass.xml
elif echo $QUERY_STRING | grep -q "tuning_id=120" ; then
	cat $DOCUMENT_ROOT/xml/reggae-island.xml
elif echo $QUERY_STRING | grep -q "tuning_id=163" ; then
	cat $DOCUMENT_ROOT/xml/ambient.xml
elif echo $QUERY_STRING | grep -q "tuning_id=21" ; then
	cat $DOCUMENT_ROOT/xml/news-talk-radio.xml
elif echo $QUERY_STRING | grep -q "tuning_id=24" ; then
	cat $DOCUMENT_ROOT/xml/top-40-pop.xml
elif echo $QUERY_STRING | grep -q "tuning_id=35" ; then
	cat $DOCUMENT_ROOT/xml/religious.xml
elif echo $QUERY_STRING | grep -q "tuning_id=36" ; then
	cat $DOCUMENT_ROOT/xml/hip-hop-rap.xml
elif echo $QUERY_STRING | grep -q "tuning_id=48" ; then
	cat $DOCUMENT_ROOT/xml/hard-rock-metal.xml
elif echo $QUERY_STRING | grep -q "tuning_id=86" ; then
	cat $DOCUMENT_ROOT/xml/college-university.xml
elif echo $QUERY_STRING | grep -q "tuning_id=11" ; then
	cat $DOCUMENT_ROOT/xml/comedy.xml
elif echo $QUERY_STRING | grep -q "tuning_id=12" ; then
	cat $DOCUMENT_ROOT/xml/blues.xml
elif echo $QUERY_STRING | grep -q "tuning_id=14" ; then
	cat $DOCUMENT_ROOT/xml/alt-rock.xml
elif echo $QUERY_STRING | grep -q "tuning_id=18" ; then
	cat $DOCUMENT_ROOT/xml/classic-rock.xml
elif echo $QUERY_STRING | grep -q "tuning_id=19" ; then
	cat $DOCUMENT_ROOT/xml/sports-radio.xml
elif echo $QUERY_STRING | grep -q "tuning_id=20" ; then
	cat $DOCUMENT_ROOT/xml/rnb-soul.xml
elif echo $QUERY_STRING | grep -q "tuning_id=3" ; then
	cat $DOCUMENT_ROOT/xml/90s-hits.xml
elif echo $QUERY_STRING | grep -q "tuning_id=4" ; then
	cat $DOCUMENT_ROOT/xml/70s-retro.xml
elif echo $QUERY_STRING | grep -q "tuning_id=5" ; then
	cat $DOCUMENT_ROOT/xml/80s-flashback.xml
elif echo $QUERY_STRING | grep -q "tuning_id=7" ; then
	cat $DOCUMENT_ROOT/xml/electronica.xml
elif echo $QUERY_STRING | grep -q "tuning_id=8" ; then
	cat $DOCUMENT_ROOT/xml/country.xml
elif echo $QUERY_STRING | grep -q "tuning_id=9" ; then
	cat $DOCUMENT_ROOT/xml/adult-contemporary.xml
else
	cat $DOCUMENT_ROOT/xml/genres.xml
fi
