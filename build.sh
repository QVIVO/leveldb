#!/bin/sh
make clean
make PLATFORM=IOS

cp -a include/leveldb $QVIVO_SDK/iphonesimulator/include/
cp -a include/leveldb $QVIVO_SDK/iphoneos/include/
cp libleveldb.a $QVIVO_SDK/iphonesimulator/lib/
cp libleveldb.a $QVIVO_SDK/iphoneos/lib/

echo "Done."