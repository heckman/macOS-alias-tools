#!/bin/zsh
set -e

cd ${0:h}

print "Cleaning old build files..."
rm -rf .build bin

VERSION="${${APP_VERSION:-0.0.1}#v}"

print "Building universal binaries for version: $VERSION"

swift build -c release --arch arm64 --arch x86_64 \
	-Xswiftc -D -Xswiftc "VERSION=\"$VERSION\""

if [[ -t 1 ]]
then
	print "\nBuild complete!"
	print "Location: ${0:A:h}/.build/apple/Products/Release/"
	ls -lh "${0:A:h}/.build/apple/Products/Release/"{readalias,mkalias}
	print "Copying binaries to ${0:A:h}/bin/"
	mkdir -p bin
	cp \
		.build/apple/Products/Release/readalias \
		.build/apple/Products/Release/mkalias \
		bin
fi
