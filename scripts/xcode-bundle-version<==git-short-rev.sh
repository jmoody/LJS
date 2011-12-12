#!/bin/sh
gitpath=`which git`
buildNumber=`$gitpath rev-parse --short HEAD`
echo $buildNumber
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$PROJECT_NAME"/"$PROJECT_NAME"-Info.plist
