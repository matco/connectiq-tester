FROM ubuntu:latest

LABEL maintainer="matthieu.corageoud@gmail.com"
LABEL version="1.1.0"
LABEL description="ConnectIQ tester"

# install required dependencies
# libwebkit2gtk-4.0-37, libusb-1.0-0, libsm6 and xvfb are required by the simulator
# openssl is required to create a fake certificate
# curl, jq, wget, unzip are required to download the SDK
RUN apt-get update && apt-get -y install \
	openjdk-17-jre-headless \
	libwebkit2gtk-4.0-37 \
	libusb-1.0-0 \
	libsm6 \
	xvfb \
	curl \
	jq \
	wget \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

# prepare ConnectIQ home folder
ENV CONNECT_IQ_HOME /connectiq
RUN mkdir -p ${CONNECT_IQ_HOME}

# hardcoding the version for now
ENV CONNECT_IQ_VERSION 4.1.4

# download the SDK
COPY downloader.sh /root/downloader.sh
RUN /root/downloader.sh $CONNECT_IQ_HOME $CONNECT_IQ_VERSION

# add ConnectIQ bin folder to the path
ENV PATH ${PATH}:${CONNECT_IQ_HOME}/bin

# manage device files
# TODO find a way to download device bits from Garmin website
COPY devices.zip /tmp/devices.zip
# devices bits must be put in /root/.Garmin/ConnectIQ/Devices/ because this path is hard-coded in the compiler and in the simulator!
# there is an undocumented option named "--override-devices-json" in the compiler class "com.garmin.monkeybrains.Monkeybrains.class"
# this option allows to specify the paths where the devices bits are stored
# unfortunately there is no such option for the simulator
RUN mkdir -p /root/.Garmin/ConnectIQ/Devices
RUN unzip /tmp/devices.zip -d /root/.Garmin/ConnectIQ/Devices

# copy custom tester script
COPY tester.sh "${CONNECT_IQ_HOME}/bin/tester.sh"

#CMD [ "/bin/bash" ]
# do not use ${CONNECT_IQ_HOME} here because variable substitution won't work
ENTRYPOINT [ "/bin/bash", "/connectiq/bin/tester.sh" ]
