default:

clean:
	-rm -rf build/*

test:
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-MacOS -configuration "Debug" -sdk macosx10.7 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-MacOS -configuration "Release" -sdk macosx10.7 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-MacOS -configuration "Debug" -sdk macosx10.8 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-MacOS -configuration "Release" -sdk macosx10.8 build
