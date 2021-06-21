#!/bin/sh
#iTunes Radio Tuner HTTP Patcher
#New URLs to inject:
NEWURL=6C6F63616C686F7374000000000000
NEWURL_LONG=687474703A2F2F6C6F63616C686F73742F786D6C2F696E6465782E786D6C3F000000000000
#Old URLs to overwrite:
OLDURL=7072692E6B74732D61662E6E657400
OLDURL_LONG=687474703A2F2F7072692E6B74732D61662E6E65742F786D6C2F696E6465782E786D6C3F00
chooseFile() {
	echo $(osascript -e 'tell application (path to frontmost application as text)
		set myFile to choose file with prompt "Where is \"iTunes.app\"?"
		POSIX path of myFile
	end')
}
ITUNES_PATH=$(chooseFile)
if [ -z "$ITUNES_PATH" ] ; then
	exit
fi
BIN_PATH="${ITUNES_PATH}Contents/MacOS/iTunes"
echo "Patching $BIN_PATH ..."
OLD_PATH="${ITUNES_PATH}Contents/MacOS/iTunes.old"
cp "$BIN_PATH" "$OLD_PATH"
rm "$BIN_PATH"
hexdump -ve '1/1 "%.2X"' "$OLD_PATH" | sed "s/$OLDURL_LONG/$NEWURL_LONG/g; s/$OLDURL/$NEWURL/g" | xxd -r -p > "$BIN_PATH"
chmod +x "$BIN_PATH"