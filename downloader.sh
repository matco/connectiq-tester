#!/bin/bash

set -eo pipefail

#retrieve parameters
DESTINATION=${1:-}
VERSION=${2:-}

#check parameters
if [[ -z $DESTINATION || -z $VERSION ]]
then
	echo "Usage: path version" >&2
	exit 1
fi

CONNECTIQ_SDK_URL="https://developer.garmin.com/downloads/connect-iq/sdks"
CONNECTIQ_SDK_INFO_URL="${CONNECTIQ_SDK_URL}/sdks.json"

#retrieve SDK file name from the version
if ! filename=$(curl -fsS "${CONNECTIQ_SDK_INFO_URL}" | jq -er --arg version "$VERSION" '.[] | select(.version == $version and (.linux | type) == "string" and (.linux | length) > 0) | .linux'); then
	echo "Unable to find Linux SDK for version $VERSION" >&2
	exit 1
fi
url="${CONNECTIQ_SDK_URL}/${filename}"
echo "Downloading from $url"

wget -nv "${url}" -O /tmp/connectiq.zip
unzip /tmp/connectiq.zip -d "${DESTINATION}"

echo "$VERSION"
