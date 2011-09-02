# This script uses appledoc to generate *.docsets that
# can viewed in Xcode and published to document feeds.
#
# It also generates nicely formated HTML documentation.
#
# By default the scripts assumes that there is a 
# Documentation directory at your project root (top level)
# directory and that this directory contains the following:
#
# 1. a templates directory with the appledoc templates in it
# 2. the appledoc executable
#
# Of course, appledoc can be installed anywhere - ditto for
# your templates.
#
# This script will only run if the build configuration
# ($BUILD_STYLE) is Release
#
# At the very minimum you MUST to change the values for
# 
# 1. AD_COMPANY 
# 2. AD_COMPANY_ID 
#
# and you'll probably want to change the AD_SOURCES
#
# The comment guide can be found here:
# http://tomaz.github.com/appledoc/comments.html
# and a settings guide can be found here:
# http://tomaz.github.com/appledoc/settings.html


# MUST CHANGE 
AD_COMPANY="AgChoice"

# MUST CHANGE (needs to be an reverse DNS id ex: com.littlejoysoftware"
AD_COMPANY_ID="au.com.agchoice"


# see the script below for examples of how to define mulitple 
# sources
AD_SOURCES="$SOURCE_ROOT"


# path to the Documentation directory (this must exist)
AD_DOC_DIRECTORY="$SOURCE_ROOT/Documentation"

# path to the templates directory (this must exist)
AD_TEMPLATES="$AD_DOC_DIRECTORY/templates"

# the name of the project
AD_PROJECT_NAME="$PROJECT_NAME"

# path to the appledoc executable (this must exist, although
# you can install appledocs where ever you want
APPLEDOC_PATH="$SOURCE_ROOT/$PROJECT_NAME/Documentation/appledoc"


# where appledoc will build the documentation
# 
# the .docset is then moved (not copied) to --docset-install-path 
# which, if not specified, will be the default location 
# ~/Library/Developer/Shared/DocSets - this is where Xcode expects
# user generated doc sets to live
#
# --keep-intermediate-files _prevents_ the html directory from being deleted 
# from the --output directory - this usually what we want so we can publish
# docs as html
# 
# This directory will be created if it does not exist
AD_BUILD_DIRECTORY="$AD_DOC_DIRECTORY/$AD_PROJECT_NAME"

# queries the project plist to find the version number
# http://discussions.apple.com/thread.jspa?threadID=2125894
# http://discussions.apple.com/thread.jspa?threadID=2330135
# set this number yourself in the project plist
AD_VERSION_NUMBER=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE"`

# range = (1, 3) - 1 is usually enough
AD_LOG_FORMAT=1

# range = (1, 6) - 3 is usually enough to see documentation errors, but it is slow
AD_VERBOSE=3

if [ "$CONFIGURATION" = Release ] 
then
  if ! [ -d "$AD_DOC_DIRECTORY" ]
  then 
    echo No directory found at "$AD_DOC_DIRECTORY" - this directory must exist
    exit 1
  fi

  if ! [ -d "$AD_TEMPLATES" ]
  then
    echo No templates directory found at "$AD_TEMPLATES" - this directory must exist and contain the appledoc templates
    exit 1
    fi
 
  if ! [ -f "$APPLEDOC_PATH" ]
  then
    echo No application found at $APPLEDOC_PATH
    echo install binary from http://www.gentlebytes.com/home/appledocapp/
    exit 1
  fi
  
  if ! [ -d "$AD_BUILD_DIRECTORY" ]
  then
    echo Did not find the build directory at "$AD_BUILD_DIRECTORY" - making it
    mkdir "$AD_BUILD_DIRECTORY"
  fi


  $APPLEDOC_PATH --output "$AD_BUILD_DIRECTORY" --templates "$AD_TEMPLATES" --project-name "$AD_PROJECT_NAME" \
--project-version "$AD_PROJECT_VERSION" --project-company "$AD_COMPANY" --company-id "$AD_COMPANY_ID" \
--create-html --create-docset --logformat "$AD_LOG_FORMAT" --verbose "$AD_VERBOSE" --keep-intermediate-files \
"$AD_SOURCES"


# multisource examples
# replace $AD_SOURCES with:
#
# --ignore "$SOURCE_ROOT/MAMFramework/Logging" \
# "$AD_SOURCES"
#
# or
#
#"$SOURCE_ROOT/MAMFramework/Utilities" \
#"$SOURCE_ROOT/MAMFramework/PlugIn Abstract Classes" \
#"$SOURCE_ROOT/MAMFramework/MAM Model Classes" \
#"$SOURCE_ROOT/MAMFramework/Error" \
#"$SOURCE_ROOT/MAMFramework/MamFramework.h" \
#"$SOURCE_ROOT/MAMFramework/MamFrameworkGlobals.h"
 
  EXIT_CODE=`echo $?`
  echo Exiting with code: $EXIT_CODE
  exit $EXIT_CODE
fi
