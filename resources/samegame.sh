#! /bin/sh

eval "$DEMO_LEAVE"

cd "$(dirname "$0")/.."
./samegame $1

eval "$DEMO_ENTER"
