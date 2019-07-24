#!/bin/bash

export SPOTIFY_NAME="${SPOTIFY_NAME:=Snapcast}"
export SPOTIFY_BITRATE="${SPOTIFY_BITRATE:=160}"

if [ -z "$PULSE_COOKIE_DATA" ]
then
    echo -ne $(echo $PULSE_COOKIE_DATA | sed -e 's/../\\x&/g') >$HOME/pulse.cookie
    export PULSE_COOKIE=$HOME/pulse.cookie
fi

#Start Dbus
service dbus start

#Start Supervisord
supervisord -c /etc/supervisord.conf

#Start Snapserver
#/usr/bin/snapserver

#Start Mopidy
#/usr/bin/mopidy

exec "$@"
