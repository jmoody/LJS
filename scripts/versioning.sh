#!/bin/sh
#
# This is a build phase run script to set the CFBundleVersion and 
# CFBundleShortVersionString for an Xcode iOS or MacOS app.
#
# to use:
#
# 1. in xcode, make a Run Script build phase with the following:
#
# sh versioning.sh "${CONFIGURATION}" "${INFOPLIST_FILE}" "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}" "${ARCHS}" AppStore
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
# LjsAppStoreBuildNumber: a number that is used to indicate the 'next' app
#                         store build.  this _must_ be managed by you at
#                         archive time - it should be +1 whatever the 
#                         current iTunes Connect record is.  eg.  if the
#                         iTC record is 1.0.11, then this number needs to be 
#                         > 12.  if you are changing minor verion, then you
#                         should reset this to zero.  if this field does not
#                         exist, it will be created
#
# CFBundleShortVersionString: short version typically set in the Summary section
#                             of the app
#   !App Store Configuration: <major>.<minor> + any number of bug fix versions
#                             eg. 0.9.3
#   
#    MacOS App Store Configuration: <major>.<minor> REQUIRED FORMAT
#                                   eg. 1.4                             
#      iOS App Store Configuration: <major>.<minor>.<build number> REQUIRED
#                                   FORMAT  eg. 1.4.1                                    
#
# CFBundleVersion - the current bundle version
#   !App Store Distribution:  <git short rev> 
#                             eg. ee168e1
#    App Store Distribution:  <short version>.<build number> REQUIRED FORMAT
#                             eg. 1.1.10
#
#############################################################################
#
############################# IMPORTANT ####################################
#  
# When archiving for the app store, if you have increased your major and/or
# minor version (CFBundleShortVersionString), you should manually reset the
# LjsAppStoreBuildNumber to zero in the info plist.
#
############################################################################

if [ $# != 5 ] ; then
    echo "usage: versioning.sh <CONFIGURATION> <INFOPLIST_FILE> <PRODUCT_INFOPLIST_PATH> <ARCHS> <APP STORE CONFIG>"
echo "Ex. sh versioning.sh \"\${CONFIGURATION}\" \"\${INFOPLIST_FILE}\" \"\${BUILT_PRODUCTS_DIR}/\${INFOPLIST_PATH}\" \"\${ARCHS}\" AppStore"
    exit 1
fi

PlistBuddyPath=/usr/libexec/PlistBuddy
CONFIGURATION="$1"
INFOPLIST_FILE="$2"
PRODUCT_INFOPLIST_FILE="$3"
ARCHS="$4"
APP_STORE_CONFIGURATION="$5"

echo "executing:"
echo "./versioning.sh ${CONFIGURATION} ${INFOPLIST_FILE} ${PRODUCT_INFOPLIST_FILE} ${ARCHS} ${APP_STORE_CONFIGURATION}"

LjsAppStoreBuildNumber=$("$PlistBuddyPath" -c "Print LjsAppStoreBuildNumber" "$INFOPLIST_FILE")
# if the build number property does not exist, create it and set it to 0
if [ `echo $?` != 0 ];
then
    echo "No entry for LjsAppStoreBuildNumber in Plist, so we create it"
    LjsAppStoreBuildNumber=0
    "$PlistBuddyPath" -c "Add :LjsAppStoreBuildNumber integer $LjsAppStoreBuildNumber" "$INFOPLIST_FILE"
fi

# app store
if [ "$CONFIGURATION" = "$APP_STORE_CONFIGURATION" ]; then
    "$PlistBuddyPath" -c "Set :LjsAppStoreBuildNumber $LjsAppStoreBuildNumber" "$INFOPLIST_FILE"
    CFBundleShortVersionString=$("$PlistBuddyPath" -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
    

    num_dots=$((`echo "$CFBundleShortVersionString"|sed 's/[^.]//g'|wc -m`-1))
    if [ $num_dots != 1 ]; then
        echo "CFBundleShortVersionString *must* be in <major>.<minor> format:  found $CFBundleShortVersionString"
        exit 1
    fi

    # mac os - CFBundleVersion <major>.<minor>.<build number>
    #          CFBundleShortVersionString <major>.<minor>
    # ios    - CFBundleVersion <major>.<minor>.<build number>
    #          CFBundleShortVersionString <major>.<minor>.<build number>
    "$PlistBuddyPath" -c "Set :CFBundleVersion $CFBundleShortVersionString.$LjsAppStoreBuildNumber" "$INFOPLIST_FILE"
    if [ "$ARCHS" = "armv7" ]; then
        bundle_version=$("$PlistBuddyPath" -c "Print CFBundleVersion" "$INFOPLIST_FILE")
        "$PlistBuddyPath" -c "Set :CFBundleShortVersionString $bundle_version" "$INFOPLIST_FILE"
    fi
else
    # use the git revision for the bundle version, except when building for the app store
    gitpath=`which git`
    GITREV=`$gitpath rev-parse --short HEAD`
    "$PlistBuddyPath" -c "Set :CFBundleVersion $GITREV" "$INFOPLIST_FILE"
fi

echo updating Info.plist at "$PRODUCT_INFOPLIST_FILE"
build_number=$("$PlistBuddyPath" -c "Print LjsAppStoreBuildNumber" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :LjsAppStoreBuildNumber $build_number" "$PRODUCT_INFOPLIST_FILE"
bundle_version=$("$PlistBuddyPath" -c "Print CFBundleVersion" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :CFBundleVersion $bundle_version" "$PRODUCT_INFOPLIST_FILE"
short_version=$("$PlistBuddyPath" -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :CFBundleShortVersionString $short_version" "$PRODUCT_INFOPLIST_FILE"


echo CONFIGURATION = "finished versioning for $CONFIGURATION and $ARCHS"
echo build number = "'$build_number'"
echo bundle version = "'$bundle_version'"
echo bundle short version = "'$short_version'"




