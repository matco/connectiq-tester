#!/bin/bash

#retrieve parameters
DESTINATION=$1
VERSION=$2

#check parameters
if [[ -z $DESTINATION ]]
then
	echo "Usage: path [version]"
	exit 1
fi

CONNECTIQ_SDK_URL="https://developer.garmin.com/downloads/connect-iq/sdks"
CONNECTIQ_SDK_INFO_URL="${CONNECTIQ_SDK_URL}/sdks.json"

#retrieve latest version if no version is specified
if [[ -z $VERSION ]]
then
	VERSION=$(curl -s "${CONNECTIQ_SDK_INFO_URL}" | jq -r '.[].version' | sort | tail -1)
	echo "Using the latest version ($VERSION)"
fi

#retrieve SDK file name from the version
filename=$(curl -s "${CONNECTIQ_SDK_INFO_URL}" | jq -r --arg version "$VERSION" '.[] | select(.version==$version) | .linux')
url="${CONNECTIQ_SDK_URL}/${filename}"
echo "Downloading from $url"

wget -q "${url}" -O /tmp/connectiq.zip;
unzip /tmp/connectiq.zip -d "${DESTINATION}"

echo "$VERSION"
