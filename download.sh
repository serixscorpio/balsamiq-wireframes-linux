#!/bin/bash

Downloaded_File=$1

# extract version from jsonp
export VERSION=$(curl -s $BALSAM_URL/win.jsonp | grep -o "[0-9]\.[0-9]*\.[0-9]*")
echo VERSION=$VERSION

# compose full URL
export DOWNLOAD_LINK="$BALSAM_URL/Balsamiq_Wireframes_${VERSION}_x64_Setup.exe"

# download and rename
curl "$DOWNLOAD_LINK" -o "$Downloaded_File"
