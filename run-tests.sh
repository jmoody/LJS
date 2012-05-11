#!/bin/sh
CC=
/usr/bin/osascript -e 'tell application "iPhone Simulator" to quit'

cd Tests-iOS
make clean;make test

cd ..
cd Tests-MacOS
make clean;make test