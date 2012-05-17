#!/bin/sh
CC=
/usr/bin/osascript -e 'tell application "iPhone Simulator" to quit'

cd Tests-iOS
make clean && WRITE_JUNIT_XML=YES make test

cd ..
cd Tests-MacOS
make clean && WRITE_JUNIT_XML=YES make test