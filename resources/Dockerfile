# This image is not meant to be run, it only stores the Garmin resources used to build the tester image.
# These resources are too large, so they are not versioned in Git.
# They are taken from the ConnectIQ folder of a local SDK Manager installation, which is used as the build context:
#  - Windows: %APPDATA%\Garmin\ConnectIQ
#  - macOS: ~/Library/Application Support/Garmin/ConnectIQ
#  - Linux: ~/.Garmin/ConnectIQ
# Build and publish this image with:
#   docker build -f resources/Dockerfile -t ghcr.io/matco/connectiq-tester-resources:2026-08-31 "<ConnectIQ folder>"
#   docker push ghcr.io/matco/connectiq-tester-resources:2026-08-31

FROM scratch

LABEL org.opencontainers.image.authors="matthieu.corageoud@gmail.com"
LABEL org.opencontainers.image.description="Garmin devices and fonts files used to build the ConnectIQ tester image"

COPY Devices /Devices/

# the .md5 files stored next to the fonts are only used by the SDK Manager to check for updates
COPY Fonts/*.cft Fonts/*.ttf /Fonts/
