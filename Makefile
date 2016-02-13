bootstrap:
	@carthage bootstrap --platform iOS

test:
	@xctool -scheme Movies -sdk iphonesimulator test -only MoviesTests

update:
	@carthage update --platform iOS
