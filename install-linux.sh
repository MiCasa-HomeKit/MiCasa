#!/bin/sh

echo "Building MiCasa"
swift build -c release

echo "Installing to /usr/local..."
cp .build/x86_64-unknown-linux-gnu/release/libHAP.so /usr/local/lib
cp .build/x86_64-unknown-linux-gnu/release/libLogging.so /usr/local/lib
cp .build/x86_64-unknown-linux-gnu/release/libMiCasaPlugin.so /usr/local/lib
cp .build/x86_64-unknown-linux-gnu/release/micasa /usr/local/bin

