default:

clean:
	-rm -rf build/*

test:
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-MacOS -configuration "Debug" -sdk macosx build
#	CC= GHUNIT_CLI=1 xcodebuild -target Tests-MacOS -configuration "Release" -sdk macosx build
