#!/bin/bash

BITS=16
DELIM="	"
DIR_DATA="."
DIR_OUT="../SD stucture/SOUNDS"
EXT_IN="aiff"
EXT_OUT="wav"
LANG_CODE="en"
PLAY=false
# `say` generates 22050 Hz sounds, OpenTX accepts 8, 16 or 32 kHz
RATE=32000
SOUNDS_CUST="custom.txt"
SOUNDS_SYS="system.txt"
SOX_VER="14.4.2"
SOX_DL_URL="https://downloads.sourceforge.net/project/sox/sox/$SOX_VER/sox-$SOX_VER-macosx.zip"
SOX_BIN="./sox-$SOX_VER/sox"
VOICE="Karen"

while getopts l:o:v:p ARG
do
  case $ARG in
    l)
      LANG_CODE=$OPTARG
      ;;
    o)
      DIR_OUT=$OPTARG
      ;;
    p)
      PLAY=true
      ;;
    v)
      VOICE=$OPTARG
  esac
done

function generate {

  # check if sox is installed
  SOX_CHECK=`"$SOX_BIN" --version 2>&1`
  if [[ $SOX_CHECK = *"No such file or directory"* ]]
  then
    install_sox
  fi

  # check if output dir is writable
  TEST_OUT="$DIR_OUT/$LANG_CODE/test"
  OUT_CHECK=`touch "$TEST_OUT" 2>&1`
  if [[ $OUT_CHECK != "" ]]
  then
    echo "Unable to write to output directory (does it exist?): $DIR_OUT/$LANG_CODE"
    exit 1
  fi
  rm "$TEST_OUT"

  # check if voice exists
  TEST_VOICE="$DIR_DATA/test.aiff"
  VOICE_CHECK=`say -o "$TEST_VOICE" -v "$VOICE" Testing 2>&1`
  if [[ $VOICE_CHECK = *"not found"* ]]
  then
    echo "Voice not installed: $VOICE"
    exit 1
  fi
  rm "$TEST_VOICE"

  echo "Reading from: $DIR_DATA/$1"
  echo "Saving to: $DIR_OUT"

  while read SOUND
  do
    # parse file name and text
    NAME=${SOUND%$DELIM*}
    TEXT=${SOUND#*$DELIM}

    # determine in/out file names
    DEST="$2/$NAME.$EXT_OUT"
    SRC="$DIR_DATA/$NAME.$EXT_IN"

    # play the sound
    if $PLAY
    then
      say -v "$VOICE" "$TEXT"
    fi

    # generate sound file
    say -o "$SRC" -v "$VOICE" "$TEXT"

    # convert to required format
    "$SOX_BIN" "$SRC" -b $BITS -r $RATE "$DEST"

    # clean up
    rm "$SRC"

    echo "Saved: $TEXT as $DEST"

  done < "$DIR_DATA/$1"
}

function install_sox {

  LOCAL_ZIP="./sox.zip"

  # download and extract
  curl -L "$SOX_DL_URL" --output "$LOCAL_ZIP"
  unzip "$LOCAL_ZIP"
  rm "$LOCAL_ZIP"
}

generate "$SOUNDS_CUST" "$DIR_OUT/$LANG_CODE"
generate "$SOUNDS_SYS" "$DIR_OUT/$LANG_CODE/SYSTEM"

echo "Sounds generated."
