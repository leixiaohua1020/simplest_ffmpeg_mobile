#!/bin/sh
# LXH,MXY
#
# directories
SOURCE="x264"
FAT="fat-x264"

SCRATCH="scratch-x264"
# must be an absolute path
THIN=`pwd`/"thin-x264"

#This is decided by your SDK version.
SDK_VERSION="8.3"

cd ./x264

#============== simulator ===============
PLATFORM="iPhoneSimulator"

#i386
ARCHS="i386"

export DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer
export SDKROOT=$DEVROOT/SDKs/${PLATFORM}${SDK_VERSION}.sdk
export CC=$DEVROOT/usr/bin/gcc
export LD=$DEVROOT/usr/bin/ld
export CXX=$DEVROOT/usr/bin/g++
export LIBTOOL=$DEVROOT/usr/bin/libtool
export HOST=i386-apple-darwin

COMMONFLAGS="-pipe -gdwarf-2 -no-cpp-precomp -isysroot ${SDKROOT} -fPIC"
export LDFLAGS="${COMMONFLAGS} -fPIC"
export CFLAGS="${COMMONFLAGS} -fvisibility=hidden"


for ARCH in $ARCHS; do

echo "Building $ARCH ......"

make clean
./configure \
--host=i386-apple-darwin \
--sysroot=$SDKROOT \
--prefix="$THIN/$ARCH" \
--extra-cflags="-arch $ARCH -miphoneos-version-min=6.0" \
--extra-ldflags="-L$SDKROOT/usr/lib/system -arch $ARCH -miphoneos-version-min=6.0" \
--enable-pic \
--enable-static \
--disable-asm \
make && make install && make clean

echo "Installed: $DEST/$ARCH"
done

#x86_64

ARCHS="x86_64"

unset DEVROOT
unset SDKROOT
unset CC
unset LD
unset CXX
unset LIBTOOL
unset HOST
unset LDFLAGS
unset CFLAGS

make clean
for ARCH in $ARCHS; do

echo "Building $ARCH ......"

./configure \
--prefix="$THIN/$ARCH" \
--enable-pic \
--enable-static \
--disable-asm \
make && make install && make clean

echo "Installed: $DEST/$ARCH"
done

#================ iphone ==================

export PLATFORM="iPhoneOS"

ARCHS="arm64 armv7 armv7s "

export DEVROOT=/Applications/Xcode.app/Contents/Developer
export SDKROOT=$DEVROOT/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDK_VERSION}.sdk
#DEVPATH=/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDK_VERSION}.sdk
export CC=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
export AS=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/as
COMMONFLAGS="-pipe -gdwarf-2 -no-cpp-precomp -isysroot ${SDKROOT} -marm -fPIC"
export LDFLAGS="${COMMONFLAGS} -fPIC"
export CFLAGS="${COMMONFLAGS} -fvisibility=hidden"
export CXXFLAGS="${COMMONFLAGS} -fvisibility=hidden -fvisibility-inlines-hidden"


for ARCH in $ARCHS; do

echo "Building $ARCH ......"

./configure \
--host=arm-apple-darwin \
--sysroot=$DEVPATH \
--prefix="$THIN/$ARCH" \
--extra-cflags="-arch $ARCH" \
--extra-ldflags="-L$DEVPATH/usr/lib/system -arch $ARCH" \
--enable-pic \
--enable-static \
--disable-asm

make && make install && make clean

echo "Installed: $DEST/$ARCH"

done

cd ..

#================ fat lib ===================

ARCHS="armv7 armv7s i386 x86_64 arm64"

echo "building fat binaries..."
mkdir -p $FAT/lib
set - $ARCHS
CWD=`pwd`
cd $THIN/$1/lib
for LIB in *.a
do
cd $CWD
lipo -create `find $THIN -name $LIB` -output $FAT/lib/$LIB
done

cd $CWD
cp -rf $THIN/$1/include $FAT




