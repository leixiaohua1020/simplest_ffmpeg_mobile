#!/bin/sh


cd ffmpeg

export PLATFORM="iPhoneOS"
export INSTALL=thin-ffmpeg
#change the below line to point to the where libx264 is
export X264ROOT=../thin-x264/arm64
export X264LIB=$X264ROOT/lib
export X264INCLUDE=$X264ROOT/include

export FAACROOT=../thin-faac/arm64
export FAACLIB=$FAACROOT/lib
export FAACINCLUDE=$FAACROOT/include

export DEVROOT=/Applications/Xcode.app/Contents/Developer

export SDKROOT=$DEVROOT/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}8.3.sdk
export CC=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
export AS=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/as

COMMONFLAGS="-pipe -gdwarf-2 -no-cpp-precomp -isysroot ${SDKROOT} -marm -fPIC"
export LDFLAGS="${COMMONFLAGS} -fPIC"
export CFLAGS="${COMMONFLAGS} -fvisibility=hidden"
export CXXFLAGS="${COMMONFLAGS} -fvisibility=hidden -fvisibility-inlines-hidden"


echo "Building arm64..."

make clean
./configure \
    --extra-cflags='-I$X264INCLUDE -I$FAACINCLUDE -arch arm64 -miphoneos-version-min=5.0 -mthumb' \
    --extra-ldflags='-L$X264LIB -L$FAACLIB -arch arm64 -miphoneos-version-min=5.0' \
    --enable-cross-compile \
    --arch=arm --disable-iconv \
    --target-os=darwin \
    --cc=${CC} --disable-asm \
    --sysroot=${SDKROOT} \
--prefix=../${INSTALL}/arm64 \
--enable-gpl --enable-nonfree --enable-version3 --disable-bzlib --enable-small \
--enable-libx264 --enable-libfaac --enable-encoder=libx264 --enable-encoder=libfaac \
--disable-ffmpeg --disable-ffprobe --disable-ffplay --disable-ffserver --disable-debug

make
make install
make clean
cd ..