#!/usr/bin/env bash

print_section_heading(){
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	printf "# ${1}\n"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
}

print_section_ending(){
	echo
	echo
	echo
}

retrieve_images_from_flickr_photos_public_feed(){
	if [[ $# -ne 1 ]]; then
		printf "retrieve_images_from_flickr_photos_public_feed() expects OUTPUT_DIR in argument\n"
	fi
	OUTPUT_DIR="${1}"
	
	printf "Downloading Flickr Photos Public Feed ...\n"
	FEED_FILE="flick_photos_public_feed.xml"
	wget --quiet "https://www.flickr.com/services/feeds/photos_public.gne" -O "${OUTPUT_DIR}/${FEED_FILE}"
	xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m "//atom:link[@type = 'image/jpeg']/@href" -v . -n "${OUTPUT_DIR}/${FEED_FILE}" >"${OUTPUT_DIR}/image_jpeg_urls.txt"
	readarray -t IMAGE_JPEG_URL_ARRAY <"${OUTPUT_DIR}/image_jpeg_urls.txt"
	printf "Found %s images in the feed\n" "${#IMAGE_JPEG_URL_ARRAY[@]}"
	for URL in "${IMAGE_JPEG_URL_ARRAY[@]}"; do
		IMAGE_FILE="${URL##*/}"
		printf "Downloading image: ${IMAGE_FILE}\n"
		wget --quiet "${URL}" -O "${OUTPUT_DIR}/${IMAGE_FILE}"
		sleep 1
	done
}

exit_script(){
	exit 1
}

trap exit_script SIGINT SIGTERM

loop_retrieve_images_from_flickr_photos_public_feed(){
	while true; do
		ROOT_IMAGES_DIR="IMAGES"
		YEAR="$(date '+%Y')"
		MONTH="$(date '+%m')"
		DAY="$(date '+%d')"
		TIME="$(date '+%H%M%S.%3N')"
		OUTPUT_DIR="${ROOT_IMAGES_DIR}/${YEAR}/${MONTH}/${DAY}/${TIME}"
		mkdir -p "${OUTPUT_DIR}"
		print_section_heading "Retrieve images from Flickr Photos Public Feed ${OUTPUT_DIR}"
		retrieve_images_from_flickr_photos_public_feed "${OUTPUT_DIR}"
		readarray -d '' IMAGE_ARRAY < <(find "${OUTPUT_DIR}" -mindepth 1 -iname '*.jpg' -print0)
		print_section_ending
	done
}

loop_retrieve_images_from_flickr_photos_public_feed

