#!/bin/sh

echo "Building MiCasa"
swift build -c release

echo "Installing to /usr/local..."
cp .build/x86_64-apple-macosx/release/libHAP.dylib /usr/local/lib
cp .build/x86_64-apple-macosx/release/libLogging.dylib /usr/local/lib
cp .build/x86_64-apple-macosx/release/libMiCasaPlugin.dylib /usr/local/lib
cp .build/x86_64-apple-macosx/release/micasa /usr/local/bin

