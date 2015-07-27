#!/bin/sh


# directories
THIN=`pwd`/"thin-ffmpeg"
FAT=`pwd`/"fat-ffmpeg"
CWD=`pwd`
# must be an absolute path


ARCHS="armv7s i386 armv7 arm64 x86_64"


echo "building fat binaries..."

mkdir -p $FAT/lib
set - $ARCHS
cd thin-ffmpeg/$1/lib
for LIB in *.a
do
cd $CWD
lipo -create `find $THIN -name $LIB` -output $FAT/lib/$LIB
done

cd $CWD
cp -rf $THIN/$1/include $FAT






