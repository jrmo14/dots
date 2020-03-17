#!/usr/bin/env bash

lang=$(ibus engine)

if [ "$lang" == "xkb:us::eng" ]; then
    echo "EN"
elif [ "$lang" == "sunpinyin" ]; then
    echo "CN"
else
    echo "?"
fi
