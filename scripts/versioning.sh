#!/bin/sh
#
# This is a build phase run script to set the CFBundleVersion and 
# CFBundleShortVersionString for an Xcode iOS or MacOS app.
#
# to use:
#
# 1. in xcode, make a Run Script build phase with the following:
#
# sh versioning.sh "${CONFIGURATION}" "${INFOPLIST_FILE}" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}" "AppStore"
#
# 2. put that build phase script at the _last_ item to run
# 3. in the project build settings make then Info.plist Output Encoding to be XML
# 4. copy this script from LJS/scripts to the SOURCE_ROOT of your target (the
#    directory with the .xcodeproj file
#
# SEE ISSUES BELOW
#
############################# IMPORTANT ####################################
# 
# CFBundleGetInfoString is deprecated
# http://openradar.appspot.com/8600732
#
#############################################################################
#
# LjsAppStoreBundleVersionNumber: an incrementing counter to keep track of 
#                                 the number of AppStore Distribution builds
#                                 that have been created.  _must_ be reset
#                                 manually when the short version string
#                                 is changed
#	
# CFBundleShortVersionString: short version typically set in the Summary section
#                             of the app
#   !App Store Configuration: <major>.<minor> + any number of bug fix versions
#                             eg. 0.9.3
#    App Store Configuration: <major>.<minor> REQUIRED FORMAT
#                             eg. 1.4                             
#
# CFBundleVersion - the current bundle version
#   !App Store Distribution:  <git short rev> 
#                             eg. ee168e1
#    App Store Distribution:  <short version>.<build number> REQUIRED FORMAT
#                             eg. 1.1.10
#
############################# IMPORTANT ####################################
#
# You must manage the CFBundleShortVersionString (eg. 0.8.5 or 2.2) manually! 
# This is usually done in the Summary tab of the target in xcode.
#
#############################################################################
#
############################# IMPORTANT ####################################
#  
# When archiving for the app store, if you have increased your major and/or
# minor version (CFBundleShortVersionString), you should manually reset the
# LjsAppStoreBundleVersionNumber to zero in the info plist.
#
############################################################################
#
##############################  ISSUES  ####################################
#  
# unless the project is cleaned, it is possible that the CFBundleVersion
# or the CFBundleShortVersionString will be out of sync in the product
# Info.plist.  i have tried many solutions to this including:
#
# http://www.cimgf.com/2011/02/20/revisiting-git-tags-and-building/
# 
# all approaches seem to have this problem
#
# since all my release are automated and/or have clean step, i am going to
# punt on this for now.  the only time it really matters if the version is
# in sync with git revision and the info plist is for releases.
#
# trying the product Info.plist rewrite approach
#############################################################################

if [ $# != 4 ] ; then
    echo "usage: versioning.sh <CONFIGURATION> <INFOPLIST_FILE> <APP STORE CONFIG>"
    exit 1
fi

PlistBuddyPath=/usr/libexec/PlistBuddy
CONFIGURATION="$1"
INFOPLIST_FILE="$2"
PRODUCT_INFOPLIST_FILE="$3"
APP_STORE_CONFIGURATION="$4"

LjsAppStoreBundleVersionNumber=$("$PlistBuddyPath" -c "Print LjsAppStoreBundleVersionNumber" "$INFOPLIST_FILE")
# if the build number property does not exist, create it and set it to 0
if [ `echo $?` != 0 ]
then
    echo "No entry for LjsAppStoreBundleVersionNumber in Plist, so we create it"
    LjsAppStoreBundleVersionNumber=0
    "$PlistBuddyPath" -c "Add :LjsAppStoreBundleVersionNumber integer $LjsAppStoreBundleVersionNumber" "$INFOPLIST_FILE"
fi

# if this is an app store release, then increment the build number
if [ "$CONFIGURATION" = "$APP_STORE_CONFIGURATION" ]; then
    LjsAppStoreBundleVersionNumber=$(($LjsAppStoreBundleVersionNumber + 1))
    "$PlistBuddyPath" -c "Set :LjsAppStoreBundleVersionNumber $LjsAppStoreBundleVersionNumber" "$INFOPLIST_FILE"
    CFBundleShortVersionString=$("$PlistBuddyPath" -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
    num_dots=$((`echo "$CFBundleShortVersionString"|sed 's/[^.]//g'|wc -m`-1))
    if [ $num_dots != 1 ]; then
        echo "CFBundleShortVersionString *must* be in <major>.<minor> format:  found $CFBundleShortVersionString"
        exit 1
    fi
    "$PlistBuddyPath" -c "Set :CFBundleVersion $CFBundleShortVersionString.$LjsAppStoreBundleVersionNumber" "$INFOPLIST_FILE"
else
    # use the git revision for the bundle version, except when building for the app store
    gitpath=`which git`
    GITREV=`$gitpath rev-parse --short HEAD`
    "$PlistBuddyPath" -c "Set :CFBundleVersion $GITREV" "$INFOPLIST_FILE"
fi

echo updating Info.plist at "$PRODUCT_INFOPLIST_FILE"
build_number=$("$PlistBuddyPath" -c "Print LjsAppStoreBundleVersionNumber" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :LjsAppStoreBundleVersionNumber $build_number" "$PRODUCT_INFOPLIST_FILE"
bundle_version=$("$PlistBuddyPath" -c "Print CFBundleVersion" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :CFBundleVersion $bundle_version" "$PRODUCT_INFOPLIST_FILE"
short_version=$("$PlistBuddyPath" -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :CFBundleShortVersionString $short_version" "$PRODUCT_INFOPLIST_FILE"


echo CONFIGURATION = "finished versioning for $CONFIGURATION"
echo build number = $build_number
echo bundle version = $build_version
echo bundle short version = $short_version




