default:

clean:
	-rm -rf build/*
test:
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "Debug" -sdk iphonesimulator build
	CC= GHUNIT_CLI=1 xcodebuild -target Tests-iOS -configuration "AdHoc" -sdk iphonesimulator build



