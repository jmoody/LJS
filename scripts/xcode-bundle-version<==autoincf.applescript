# make a Run Script build phase
# with shell /usr/bin/osascript
# set bundle version in info.plist to $CURRENT_PROJECT_VERSION
tell application "Xcode"
	set prj to system attribute "PROJECT_NAME"
	repeat with config in build configurations of project prj
		try
			set x to build setting "CURRENT_PROJECT_VERSION" of config
			set value of x to ((((value of x) as number) + 1) as string)
		on error
			set value of build setting "CURRENT_PROJECT_VERSION" of config to "1"
		end try
	end repeat
end tell
set srcrt to system attribute "SRCROOT"
set iplstf to system attribute "INFOPLIST_FILE"
do shell script "touch " & srcrt & "/" & iplstf