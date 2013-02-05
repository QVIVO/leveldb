#!/bin/sh

make clean
make library
make clean
make IOS=1 library
make clean
make IOS=2 library
make lipo

cp libleveldb.a $QVIVO_SDK/iphonesimulator/lib/
cp libleveldb.a $QVIVO_SDK/iphoneos/lib/