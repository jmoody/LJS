#!/bin/bash
# This is a build phase run script to set various properties in the info plist 
# of an Xcode project.  The values that are set are:
# CFBuildNumber - an incrementing counter to keep track of the number of App Store
#                 Distribution builds have been created
# CFBundleGetInfoString - verbose details about current build
#   !App Store Configuration: MyApp 1.0.5 ee168e1 De
#    App Store Configuration: MyApp 1.2 1.2.1
# CFBundleVersion - the current bundle version
#   !App Store Distribution:  <git short rev> e.g. ee168e1
#    App Store Distribution:  <short version>.<build number>
#
# You must manage the CFBundleShortVersionString manually!
# You must reset the CFBuildNumber manually for each new short version string!
#
# Rules
# 1. depends on a build configuration "App Store Distribution"
# 2. you must manage your short version string manually
# 3. keep your app store distribution short version string to *.* 
# 4. the build number is used to create bundle version for App Store distributions which
#    only allows *.*.* bundle version

PlistBuddyPath=/usr/libexec/PlistBuddy
LjsAppStoreDistributionConfiguration="App Store Distribution"

CFBuildNumber=$("$PlistBuddyPath" -c "Print CFBuildNumber" "$INFOPLIST_FILE")
# if the build number property does not exist, create it and set it to 0
if [ `echo $?` != 0 ]
then
echo "No entry for CFBuildNumber in Plist, so we create it"
CFBuildNumber=0
"$PlistBuddyPath" -c "Add :CFBuildNumber integer $CFBuildNumber" "$INFOPLIST_FILE"
fi

# if this is an app store release, then increment the build number
if [ "$CONFIGURATION" = "$LjsAppStoreDistributionConfiguration" ] 
then 
CFBuildNumber=$(($CFBuildNumber + 1))
"$PlistBuddyPath" -c "Set :CFBuildNumber $CFBuildNumber" "$INFOPLIST_FILE"
fi


# if the get info string property does not exist, create it
CFBundleGetInfoString=$("$PlistBuddyPath" -c "Print CFBundleGetInfoString" "$INFOPLIST_FILE")
if [ `echo $?` != 0 ]
then
echo "No entry for CFBundleGetInfoString in Plist, so we create it"
"$PlistBuddyPath" -c "Add :CFBundleGetInfoString string \"NEWLY CREATED\"" "$INFOPLIST_FILE"
fi



# use the git revision for the bunlde version, except when building for the app store
gitpath=`which git`
CFBundleVersion=`$gitpath rev-parse --short HEAD`
CFBundleShortVersionString=$("$PlistBuddyPath" -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")


if [ "$CONFIGURATION" != "$LjsAppStoreDistributionConfiguration" ] 
then
CFBundleVersion_CURRENT=$("$PlistBuddyPath" -c "Print CFBundleVersion" "$INFOPLIST_FILE")
if [ "$CFBundleVersion" != "$CFBundleVersion_CURRENT" ]
then
echo "Bundle version has changed:  $CFBundleVersion_CURRENT ==> $CFBundleVersion - updating plist"
"$PlistBuddyPath" -c "Set :CFBundleVersion $CFBundleVersion" "$INFOPLIST_FILE"
else
echo "CFBundleVersion has not changed, no need to update plist"  
fi
BUILD_CONFIGURATION_ABBR=${CONFIGURATION:0:2} 
CFBundleGetInfoString="$PRODUCT_NAME $CFBundleShortVersionString $CFBundleVersion $BUILD_CONFIGURATION_ABBR"
CFBundleGetInfoString_CURRENT=$("$PlistBuddyPath" -c "Print CFBundleGetInfoString" "$INFOPLIST_FILE")
if [ "$CFBundleGetInfoString" != "$CFBundleGetInfoString_CURRENT" ]
then
echo "Info String has changed:  $CFBundleGetInfoString_CURRENT ==> $CFBundleGetInfoString - updating plist"
"$PlistBuddyPath" -c "Set :CFBundleGetInfoString $CFBundleGetInfoString" "$INFOPLIST_FILE"
else
echo "CFBundleGetInfoString has not changed, no need to update plist"
fi
else
# no need to check if the get info string has changed, but it necessarily will have because
# the build number is incremented
"$PlistBuddyPath" -c "Set :CFBundleVersion $CFBundleShortVersionString.$CFBuildNumber" "$INFOPLIST_FILE"
CFBundleGetInfoString="$PROJECT_NAME $CFBundleShortVersionString.$CFBuildNumber"
"$PlistBuddyPath" -c "Set :CFBundleGetInfoString $CFBundleGetInfoString" "$INFOPLIST_FILE"
fi



echo CONFIGURATION = "$CONFIGURATION"
echo build number = $("$PlistBuddyPath" -c "Print CFBuildNumber" "$INFOPLIST_FILE")
echo bundle version = $("$PlistBuddyPath" -c "Print CFBundleVersion" "$INFOPLIST_FILE")
echo bundle short version = $("$PlistBuddyPath" -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
echo bundle info string = $("$PlistBuddyPath" -c "Print CFBundleGetInfoString" "$INFOPLIST_FILE")

