#!/usr/bin/env python3

import sys
import dbus
import argparse
from mpd import MPDClient


def query_spotify():
    try:
        spotify_bus = dbus.SessionBus().get_object("org.mpris.MediaPlayer2.spotify", '/org/mpris/MediaPlayer2')
        spot_prop = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
        metadata = spot_prop.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
        status = spot_prop.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')
        artist = str(metadata['xesam:artist'][0])
        song = str(metadata['xesam:title'])
        return artist, song

    except Exception as e:
        return None


def query_mpd(host="127.0.0.1", port=6600, force=False):
    client = MPDClient()
    try:
        client.connect(host, port)
        cur = client.currentsong()
        artist = cur['artist']
        song = cur['title']
        if client.status()['state'] == 'pause' and not force:
            return ''
        return artist, song
    except:
        return None

def trunc(x, trunclen):
    if len(x) > trunclen:
        x = x[:trunclen]
        x += '...'
        if ('(' in x) and (')' not in x):
            x += ')'
    return x



if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-s',
        '--trunclen_song',
        type=int,
        metavar='trunclen_song',
    )
    parser.add_argument(
        '-a',
        '--trunclen_artist',
        type=int,
        metavar='trunclen_artist',
    )
    parser.add_argument(
        '-f',
        '--format',
        type=str,
        metavar='custom format',
        dest='custom_format'
    )

    args = parser.parse_args()

    # Default parameters
    output = '{artist} -- {song}'
    trunclen_song = 25
    trunclen_artist = 25

    ret = query_mpd()
    if ret is None or ret is '':
        ret = query_spotify()
    if ret is None:
        ret = query_mpd(force=True)
        if ret is None:
            print('')
            sys.exit(0)
    artist, song = ret
    song = trunc(song, trunclen_song)
    artist = trunc(artist, trunclen_artist)
    print(output.format(artist=artist, song=song))

