default:

clean:
	-rm -rf build/*

test:
	CC= GHUNIT_CLI=1 xcodebuild -target RiseUpTests -configuration "AdHoc" -sdk iphonesimulator build
	CC= GHUNIT_CLI=1 xcodebuild -target RiseUpTests -configuration "Debug" -sdk iphonesimulator build