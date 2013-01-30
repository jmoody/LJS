#!/bin/sh

# If we aren't running from the command line, then exit
if [ "$GHUNIT_CLI" = "" ] && [ "$GHUNIT_AUTORUN" = "" ]; then
exit 0
fi

export DYLD_ROOT_PATH="$SDKROOT"
export DYLD_FRAMEWORK_PATH="$CONFIGURATION_BUILD_DIR"
export IPHONE_SIMULATOR_ROOT="$SDKROOT"
export CFFIXED_USER_HOME="/dev/null"

export NSDebugEnabled=YES
export NSZombieEnabled=YES
export NSDeallocateZombies=NO
export NSHangOnUncaughtException=YES
export NSAutoreleaseFreedObjectCheckEnabled=YES

export GHUNIT_RUN_TESTS_SCRIPT=YES

export DYLD_FRAMEWORK_PATH="$CONFIGURATION_BUILD_DIR"

TEST_TARGET_EXECUTABLE_PATH="$TARGET_BUILD_DIR/$EXECUTABLE_PATH"

# to get growl notifications, add a GROWLNOTIFY variable to your environment
SDKNAME=`basename $SDKROOT`
GROWLNOTIFY_MESSAGE_PASS="$PRODUCT_NAME $SDKNAME ==> $CONFIGURATION"$'\n'"All tests passed!"
GROWLNOTIFY_ICON_PASS="../art/growl/tests-pass.png"
GROWLNOTIFY_MESSAGE_FAIL="$PRODUCT_NAME ==> $SDKNAME $CONFIGURATION"$'\n'"Some tests failed. :("
GROWLNOTIFY_ICON_FAIL="../art/growl/tests-fail.png"

if [ ! -e "$TEST_TARGET_EXECUTABLE_PATH" ]; then
echo ""
echo "  ------------------------------------------------------------------------"
echo "  Missing executable path: "
echo "     $TEST_TARGET_EXECUTABLE_PATH."
echo "  The product may have failed to build or could have an old xcodebuild in your path (from 3.x instead of 4.x)."
echo "  ------------------------------------------------------------------------"
echo ""
exit 1
fi

RUN_CMD="\"$TEST_TARGET_EXECUTABLE_PATH\" -RegisterForSystemEvents"

echo "Running: $RUN_CMD"
set +o errexit # Disable exiting on error so script continues if tests fail
eval $RUN_CMD
RETVAL=$?
set -o errexit

unset DYLD_ROOT_PATH
unset DYLD_FRAMEWORK_PATH
unset IPHONE_SIMULATOR_ROOT

WRITE_JUNIT_XML=1

if [ -n "$WRITE_JUNIT_XML" ]; then
    MY_TMPDIR=`/usr/bin/getconf DARWIN_USER_TEMP_DIR`
    RESULTS_DIR="${MY_TMPDIR}test-results"
    
    if [ -d "$RESULTS_DIR" ]; then
        `$CP -r "$RESULTS_DIR" "$BUILD_DIR" && rm -r "$RESULTS_DIR"`
    fi
fi

if [ "$GROWLNOTIFY" = "" ]; then
    echo "skipping growl notification - could not find a grownlnotify"
else
    set +o errexit # Disable exiting on error so script continue if find-process fails
    GROWL_PROCESS=`ps auxw | grep Growl | grep -v grep`
    GROWL_RUNNING=$?
    if [ $GROWL_RUNNING = 1 ]; then
        echo "skipping growl notifcation - could not find a Growl server running"
    else
        if [ $RETVAL = 0 ]; then
            $GROWLNOTIFY --name Xcode --image $GROWLNOTIFY_ICON_PASS --message "$GROWLNOTIFY_MESSAGE_PASS"
        else
            $GROWLNOTIFY --name Xcode --image $GROWLNOTIFY_ICON_FAIL --message "$GROWLNOTIFY_MESSAGE_FAIL"
        fi
    fi
    set -o errexit
fi


exit $RETVAL
