#!/usr/bin/env bash

function m3u8_to_mp4(){
	ffmpeg -i "${1}" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "${2}"
}
alias m3u8_to_mp4=m3u8_to_mp4
