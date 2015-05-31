#!/usr/bin/env bash

# @author Srijan Mukherjee
## Depends:
# 1. Lame for decoding mp3 to wav
# 2. Nero AAC Encoder for encoding to AAC
# 3. ffmpeg for mux AAC -> m4a container

help()  {
  echo "Usage: $0 [-b <bitate (bits)>] [-i <input-file>]" 1>&2;
  exit 1;
}

tmpfile=/tmp/tmp.aac
bitrate=128000

# main()
while getopts ":b:i:h" o; do
   case "${o}" in
      b)
        bitrate=${OPTARG}
        ;;
      h)
        help
        ;;
      i)
        infile=${OPTARG}
        ;;
      *)
        help
        ;;
   esac
done

if [ $OPTIND -eq 1 ]; then help; fi

filename=$(basename "$infile")
#extension="${filename##*.}"
filename="${filename%.*}"

# Decode the MP3 to wave and encode to aac. We will use
# /tmp as the temporary storage and so make sure you have enough space for
# the aac file there
lame --decode "${infile}" - | neroAacEnc -lc -cbr ${bitrate} -if - -of ${tmpfile}

# Mux the generated AAC to the target M4A file
ffmpeg -i ${tmpfile} -codec: copy "${filename}.m4a"

#Delete the tmpfile
rm -f ${tmpfile}
