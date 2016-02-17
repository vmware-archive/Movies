bootstrap:
	@carthage bootstrap --platform iOS

sort:
	@./bin/sortXcodeProjectFile  Movies.xcodeproj/project.pbxproj

test:
	@xctool -scheme Movies -sdk iphonesimulator test -only MoviesTests

update:
	@carthage update --platform iOS
