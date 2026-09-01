# the devices and fonts files are stored in a dedicated image because they are too big to be versioned in Git
# this image is built and published manually, see resources/Dockerfile
ARG RESOURCES_VERSION=2026-08-31
FROM ghcr.io/matco/connectiq-tester-resources:${RESOURCES_VERSION} AS resources

FROM ubuntu:jammy AS downloader

# install required dependencies
# curl, jq, wget are required to download the SDK
RUN apt-get update && apt-get -y install \
	curl \
	jq \
	wget \
	&& apt-get clean

# prepare ConnectIQ home folder
ENV CONNECT_IQ_HOME=/connectiq
RUN mkdir -p ${CONNECT_IQ_HOME}

# hardcoding the version for now
ENV CONNECT_IQ_VERSION=9.2.0

# download the SDK
COPY downloader.sh /root/downloader.sh
RUN /root/downloader.sh $CONNECT_IQ_HOME $CONNECT_IQ_VERSION

FROM ubuntu:jammy AS tester

LABEL org.opencontainers.image.authors="matthieu.corageoud@gmail.com"
LABEL org.opencontainers.image.description="ConnectIQ tester"

# install required dependencies
# libwebkit2gtk-4.0-37, libusb-1.0-0, libsm6 and xvfb are required by the simulator
# openssl is required to create a fake certificate
RUN apt-get update && apt-get -y install \
	openjdk-17-jre-headless \
	libwebkit2gtk-4.0-37 \
	libusb-1.0-0 \
	libsm6 \
	xvfb \
	&& apt-get clean

# prepare ConnectIQ home folder
ENV CONNECT_IQ_HOME=/connectiq
RUN mkdir -p ${CONNECT_IQ_HOME}

# retrieve downloaded SDK from the downloader image
COPY --from=downloader /connectiq /connectiq

# add ConnectIQ bin folder to the path
ENV PATH=${PATH}:${CONNECT_IQ_HOME}/bin

# manage device files
# devices bits must be put in /root/.Garmin/ConnectIQ/Devices/ because this path is hard-coded in the compiler and in the simulator!
# there is an undocumented option named "--override-devices-json" in the compiler class "com.garmin.monkeybrains.Monkeybrains.class"
# this option allows to specify the paths where the devices bits are stored
# unfortunately there is no such option for the simulator
COPY --from=resources /Devices /root/.Garmin/ConnectIQ/Devices

# manage font files
# fonts must be put in /root/.Garmin/ConnectIQ/Fonts/ because this path is hard-coded in the simulator
# without them, the simulator is unable to rasterize any text and fails with "Invalid Font Specified"
COPY --from=resources /Fonts /root/.Garmin/ConnectIQ/Fonts

# copy custom tester script
COPY tester.sh "${CONNECT_IQ_HOME}/bin/tester.sh"

# do not use ${CONNECT_IQ_HOME} here because variable substitution won't work
ENTRYPOINT [ "/bin/bash", "/connectiq/bin/tester.sh" ]
