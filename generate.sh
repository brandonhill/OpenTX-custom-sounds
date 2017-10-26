#!/bin/bash

BITS=16
DELIM_DATA="	"
DELIM_ARGS=":"
DIR_DATA="."
DIRS_OUT=("../SD structure/SOUNDS")
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
      IFS="$DELIM_ARGS" read -a DIRS_OUT <<< "$OPTARG"
      for (( i=0; i<${#DIRS_OUT[@]}; i++))
      do
        DIRS_OUT[$i]="${DIRS_OUT[$i]/#\~/$HOME}"
      done
      ;;
    p)
      PLAY=true
      ;;
    v)
      VOICE=$OPTARG
  esac
done

function dir_writable {
  TEST_OUT="$1/test"
  OUT_CHECK=`touch "$TEST_OUT" 2>&1`
  if [[ $OUT_CHECK != "" ]]
  then
    
    # try to make it
    MKDIR=`mkdir -p "$1" 2>&1`
    if [[ $MKDIR != "" ]]
    then
      return 0
    fi
  fi
  rm -f "$TEST_OUT"
  return 1
}

function generate {

  DATA_FILE="$DIR_DATA/$1"

  # check if sox is installed
  sox_installed
  if [[ $? = 0 ]]
  then
    sox_install
  fi

  # check if output dirs are writable
  for DIR_OUT in "${DIRS_OUT[@]}"
  do
    dir_writable "$DIR_OUT/$LANG_CODE$2"
    if [[ $? = 0 ]]
    then
      echo "Unable to write to output directory (does it exist?): $DIR_OUT$2"
      exit 1
    fi
  done  

  # check if voice exists
  voice_installed "$VOICE"
  if [[ $? = 0 ]]
  then
    echo "Voice not installed: $VOICE"
    exit 1
  fi

  echo "Reading from: $DATA_FILE"

  while read SOUND
  do
    # parse file name and text
    NAME=${SOUND%$DELIM_DATA*}
    TEXT=${SOUND#*$DELIM_DATA}

    # determine in/out file names
    FILE_SRC="$DIR_DATA/$NAME.$EXT_IN"
    FILE_TMP="$DIR_DATA/$NAME.$EXT_OUT"

    # play the sound
    if $PLAY
    then
      say -v "$VOICE" "$TEXT"
    fi

    # generate sound file
    say -o "$FILE_SRC" -v "$VOICE" "$TEXT"

    # convert to required format
    "$SOX_BIN" "$FILE_SRC" -b $BITS -r $RATE "$FILE_TMP"

    echo "Generated \"$TEXT\""

    # copy to output directories
    for DIR_OUT in "${DIRS_OUT[@]}"
    do
      FILE_DEST="$DIR_OUT/$LANG_CODE$2/$NAME.$EXT_OUT"
      cp "$FILE_TMP" "$FILE_DEST"
      echo "Saved to $FILE_DEST"
    done  

    # clean up
    rm "$FILE_SRC"
    rm "$FILE_TMP"

  done < "$DATA_FILE"
}

function sox_install {
  LOCAL_ZIP="./sox.zip"
  curl -L "$SOX_DL_URL" --output "$LOCAL_ZIP"
  unzip "$LOCAL_ZIP"
  rm "$LOCAL_ZIP"
}

function sox_installed {
  SOX_CHECK=`"$SOX_BIN" --version 2>&1`
  if [[ $SOX_CHECK = *"No such file or directory"* ]]
  then
    return 0
  fi
  return 1
}

function voice_installed {
  TEST_VOICE="$DIR_DATA/test.aiff"
  VOICE_CHECK=`say -o "$TEST_VOICE" -v "$1" Testing 2>&1`
  if [[ $VOICE_CHECK = *"not found"* ]]
  then
    return 0
  fi
  rm "$TEST_VOICE"
  return 1
}

generate "$SOUNDS_CUST"
generate "$SOUNDS_SYS" "/SYSTEM"

echo "Sounds generated."
