run:
	dart run bin/main.dart
compile:
	dart compile exe bin/main.dart -o supagen
release:
	git tag -a $(version) -m "Release $(version)"
	git push origin $(version)
changelog:
	git log --pretty=format:"%s" $(shell git describe --tags --abbrev=0)..HEAD > releases.txt
