default:

clean:
	-rm -rf build/*

test:
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "Debug" -sdk iphonesimulator5.1 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "AdHoc" -sdk iphonesimulator5.1 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "Debug" -sdk iphonesimulator6.0 build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "AdHoc" -sdk iphonesimulator6.0 build


