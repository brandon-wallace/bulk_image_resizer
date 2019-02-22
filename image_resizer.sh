#!/bin/bash -


OUTPUT_PATH=resized
FORMAT=""
OUTPUT_WIDTH=200
PERCENTAGE=25


if [ ! -x /usr/bin/mogrify ]; then

    printf "%s\n" "imagemagick is not installed."
    exit 1

fi


function to_lowercase() {
    for i in $1; do
        rename 'y/A-Z/a-z/' ${i}
    done
}


function jpeg_to_jpg() {
    for i in $1; do
        rename 's/jpeg/jpg/' ${i}
    done
}


printf "%s\n%s\n" "1. JPG" "2. PNG" 
read -n 1 -p "Select a number: " answer


case $answer in

    1) 
        echo "JPG"
        FORMAT="*.jpg"
        jpeg_to_jpg "*.jpeg"
        to_lowercase "*.JPG"
        ;;
    2)
        echo "PNG"
        FORMAT="*.png"
        to_lowercase "*.PNG"
        ;;
    *)
        echo "Invalid selection"
        exit 1
        ;;

esac


if [ ! -d $OUTPUT_PATH ]; then

    mkdir -v $OUTPUT_PATH

fi


printf "%s\n" "Please wait..."
for i in $FORMAT; do

    mogrify -path ${OUTPUT_PATH} -filter Triangle -define filter:support=2 -thumbnail ${OUTPUT_WIDTH} -unsharp 0.25x0.25+8+0.065 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling -define png:compress-filter=5 -define png:compression-level=9 -define compression-strategy=1 -define png:exclude-chunk-all -interlace none -colorspace sRGB -resize ${PERCENTAGE}% -strip "${i}"

done
