FROM debian:stretch-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y \
  wget \
  gnupg \
  python-pip \
  build-essential \
  libasound2-dev \
  libvorbisidec-dev \
  libvorbis-dev \
  libflac-dev \
  alsa-utils \
  libavahi-client-dev \
  avahi-daemon \
  supervisor \
  && apt-get update

# Snapcast install 
ARG SNAPCAST_VERSION=0.15.0
ARG SNAPCAST_PORT=1704

RUN wget 'https://github.com/badaix/snapcast/releases/download/v'$SNAPCAST_VERSION'/snapserver_'$SNAPCAST_VERSION'_amd64.deb' \
  && dpkg -i --force-all 'snapserver_'$SNAPCAST_VERSION'_amd64.deb' \
  && apt-get -f install -y

# Mopidy install 
ENV MOPIDY_HOME=/var/lib/mopidy
ARG MOPIDY_API_PORT=6600
ARG MOPIDY_WEB_PORT=6680

# Install Mopidy && extentions
RUN wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add - \
  && wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list \
  && apt-get update \
  && apt-get install -f -y \
  mopidy \
  mopidy-soundcloud \
  mopidy-spotify

RUN pip install Mopidy-API-Explorer \
  Mopidy-MusicBox-Webclient \
  Mopidy-Iris \
  Mopidy-Moped

# Final clean
RUN apt-get autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# COPY ./mopidy.conf ${MOPIDY_HOME}/.config/mopidy/mopidy.conf
 
# Some scripts
RUN mkdir -p /var/run/dbus \
    && chown messagebus:messagebus /var/run/dbus \
    && dbus-uuidgen --ensure 
    
ADD ./start.sh /start.sh
RUN chmod a+x /start.sh
ADD ./supervisord.conf /etc/supervisord.conf

# Snapcast Ports
EXPOSE ${SNAPCAST_PORT}

# Mopidy Ports
EXPOSE ${MOPIDY_API_PORT} ${MOPIDY_WEB_PORT} 5555/udp

# Avahi port
EXPOSE 5353
 
ENTRYPOINT ["/start.sh"]
#CMD ["/bin/bash", "/start.sh"]
