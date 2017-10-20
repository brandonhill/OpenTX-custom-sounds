#!/bin/bash

BITS=16
DELIM="\	"
DIR=".."
DIR_IN="."
DIR_OUT="${DIR}/SD stucture/SOUNDS/en"
EXT_IN="aiff"
EXT_OUT="wav"
PLAY=false
RATE=16000
SOUNDS_CUST="custom.txt"
SOUNDS_SYS="system.txt"
VOICE="Karen"

while getopts ":pv" ARG
do
	case $ARG in
		p)
			PLAY=true
			;;
		v)
			VOICE=$OPTARG
	esac
done

function generate {

	echo "Reading from: $DIR_IN/$1"

	while read SOUND
	do
		NAME=${SOUND%$DELIM*}
		TEXT=${SOUND#*$DELIM}

		DEST="$2/$NAME.$EXT_OUT"
		SRC="$DIR_IN/$NAME.$EXT_IN"

		if $PLAY
		then
			say -v "$VOICE" "$TEXT"
		fi
		say -o "$SRC" -v "$VOICE" "$TEXT"
		sox "$SRC" -b $BITS -r $RATE "$DEST"
		rm "$SRC"

		echo "Saved: $TEXT to $DEST"

	done < "$DIR_IN/$1"
}

generate "$SOUNDS_CUST" "$DIR_OUT"
generate "$SOUNDS_SYS" "$DIR_OUT/SYSTEM"

echo "Sounds generated."
