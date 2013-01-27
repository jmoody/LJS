#!/bin/sh
# eventually pass in INFOPLIST_FILE BUILT_PRODUCTS_DIR and INFOPLIST_PATH
PlistBuddyPath=/usr/libexec/PlistBuddy
PRODUCT_INFOPLIST_FILE="${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"
build_number=$("$PlistBuddyPath" -c "Print CFBuildNumber" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :CFBuildNumber $build_number" "$PRODUCT_INFOPLIST_FILE"

bundle_version=$("$PlistBuddyPath" -c "Print CFBundleVersion" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :CFBundleVersion $bundle_version" "$PRODUCT_INFOPLIST_FILE"

short_version=$("$PlistBuddyPath" -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
"$PlistBuddyPath" -c "Set :CFBundleShortVersionString $short_version" "$PRODUCT_INFOPLIST_FILE"