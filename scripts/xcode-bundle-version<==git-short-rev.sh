#!/bin/sh

# requires that you seed the CFBundleVersion in the Info.plist
# with a value (an value will do)
gitpath=`which git`
buildNumber=`$gitpath rev-parse --short HEAD`
echo $buildNumber
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"
