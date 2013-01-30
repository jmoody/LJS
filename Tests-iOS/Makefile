default:

clean:
	-rm -rf build/*

test_ios5:
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "Debug" -sdk iphonesimulator5.1 build

test_ios6:
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "Debug" -sdk iphonesimulator6.1 build
test:
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "Debug" -sdk iphonesimulator5.1 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "AdHoc" -sdk iphonesimulator5.1 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "Debug" -sdk iphonesimulator6.0 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "AdHoc" -sdk iphonesimulator6.0 build


