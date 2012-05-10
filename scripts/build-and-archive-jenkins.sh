cd RiseUp
CC=
SIGNING_IDENTITY="iPhone Distribution: Recovery Warriors L.L.C."
PROVISIONING_PROFILE="../certs/recoverywarriors/RiseUp/RiseUp_RW_iOS_AdHoc_Distribution_Profile.mobileprovision"
PRODUCT_NAME="RiseUp"
CONFIGURATION_BUILD_DIR="./build"

/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -scheme RiseUp archive -configuration AdHoc -sdk iphoneos

/usr/bin/security list-keychains -s "${HOME}/Library/Keychains/login.keychain"
/usr/bin/security default-keychain -d user -s "${HOME}/Library/Keychains/login.keychain"
/usr/bin/security unlock-keychain -p wonderstanding "${HOME}/Library/Keychains/login.keychain"

DATE=$( /bin/date +"%Y-%m-%d" )
ARCHIVE=$( /bin/ls -t "${HOME}/Library/Developer/Xcode/Archives/${DATE}" | /usr/bin/grep xcarchive | /usr/bin/sed -n 1p )
DSYM="${HOME}/Library/Developer/Xcode/Archives/${DATE}/${ARCHIVE}/dSYMs/${PRODUCT_NAME}.app.dSYM"
#DSYM="${CONFIGURATION_BUILD_DIR}/${PRODUCT_NAME}.app.dSYM"                                                                                                                            
APP="${HOME}/Library/Developer/Xcode/Archives/${DATE}/${ARCHIVE}/Products/Applications/${PRODUCT_NAME}.app"
#APP="${CONFIGURATION_BUILD_DIR}/${PRODUCT_NAME}.app"                                                                                                                                  

IPA="${HOME}/tmp/${PRODUCT_NAME}.ipa"


/Applications/Xcode.app/Contents/Developer/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${APP}" -o "${IPA}" --sign "${SIGNING_IDENTITY}" --embed "${PROVISIONING_PROFILE}"

/bin/cp "${IPA}" "${CONFIGURATION_BUILD_DIR}"
/bin/rm "${IPA}"

DSYM_ZIP="${CONFIGURATION_BUILD_DIR}/${PRODUCT_NAME}.app.dSYM.zip"
#/bin/cp -r "${DSYM}" "${CONFIGURATION_BUILD_DIR}"                                                                                                                                     
echo dsym zip = "${DSYM_ZIP}"
echo dysm = "${DSYM}"
/usr/bin/zip -r "${DSYM_ZIP}" "${DSYM}"