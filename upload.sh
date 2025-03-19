#!/bin/bash

set -euo pipefail

# Set default values for environment variables
: "${HTTP_URL:=https://webcam.connect.prusa3d.com/c/snapshot}"
: "${DELAY_SECONDS:=10}"
: "${LONG_DELAY_SECONDS:=60}"

while true; do
    # Grab a frame from the RTSP stream using FFmpeg (timeout at 5s)
    ffmpeg \
        -timeout 5000000 \
        -loglevel quiet \
        -stats \
        -y \
        -rtsp_transport tcp \
        -i "$RTSP_URL" \
        -f image2 \
        -vframes 1 \
        -pix_fmt yuvj420p \
        output.jpg

    # If no error, upload it.
    if [ $? -eq 0 ]; then
        # POST the image to the HTTP URL using curl
        curl -X PUT "$HTTP_URL" \
            -H "accept: */*" \
            -H "content-type: image/jpg" \
            -H "fingerprint: $FINGERPRINT" \
            -H "token: $TOKEN" \
            --data-binary "@output.jpg" \
            --no-progress-meter \
            --compressed

        # Reset delay to the normal value
        DELAY=$DELAY_SECONDS
    else
        echo "FFmpeg returned an error. Retrying after ${LONG_DELAY_SECONDS}s..."

        # Set delay to the longer value
        DELAY=$LONG_DELAY_SECONDS
    fi

    sleep "$DELAY"
done

