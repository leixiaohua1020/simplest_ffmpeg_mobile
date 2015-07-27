#!/bin/sh
# LXH,MXY modified

cd ffmpeg

PLATFORM="iPhoneSimulator"
INSTALL="thin-ffmpeg"
SDK_VERSION="8.3"

# libx264
export X264ROOT=../thin-x264/i386
export X264LIB=$X264ROOT/lib
export X264INCLUDE=$X264ROOT/include
# libfaac
export FAACROOT=../thin-faac/i386
export FAACLIB=$FAACROOT/lib
export FAACINCLUDE=$FAACROOT/include

export DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer
export SDKROOT=$DEVROOT/SDKs/${PLATFORM}${SDK_VERSION}.sdk
export CC=$DEVROOT/usr/bin/gcc
export LD=$DEVROOT/usr/bin/ld

export CXX=$DEVROOT/usr/bin/g++

export LIBTOOL=$DEVROOT/usr/bin/libtool

COMMONFLAGS="-pipe -gdwarf-2 -no-cpp-precomp -isysroot ${SDKROOT} -fPIC"
export LDFLAGS="${COMMONFLAGS} -fPIC"
export CFLAGS="${COMMONFLAGS} -fvisibility=hidden"


echo "Building i386..."
make clean
./configure \
    --cpu=i386 \
    --extra-cflags='-I$X264INCLUDE -I$FAACINCLUDE -arch i386 -miphoneos-version-min=5.0' \
    --extra-ldflags='-L$X264LIB -L$FAACLIB -arch i386 -miphoneos-version-min=5.0' \
    --enable-cross-compile \
    --arch=i386 --disable-iconv \
    --target-os=darwin \
    --cc=${CC} \
    --sysroot=${SDKROOT} \
--prefix=../${INSTALL}/i386 \
--enable-gpl --enable-nonfree --enable-version3 --disable-bzlib --enable-small --disable-vda \
--disable-encoders --enable-libx264 --enable-libfaac --enable-encoder=libx264 --enable-encoder=libfaac \
--disable-muxers --enable-muxer=flv --enable-muxer=mov --enable-muxer=mpegts --enable-muxer=ipod --enable-muxer=psp --enable-muxer=mp4 --enable-muxer=avi \
--disable-decoders --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=h264 --enable-decoder=mpeg4 \
--disable-demuxers --enable-demuxer=flv --enable-demuxer=h264 --enable-demuxer=mpegts --enable-demuxer=avi --enable-demuxer=mpc --enable-demuxer=mov \
--disable-parsers --enable-parser=aac --enable-parser=ac3 --enable-parser=h264 \
--disable-protocols --enable-protocol=file --enable-protocol=rtmp --enable-protocol=rtp --enable-protocol=udp \
--disable-bsfs --enable-bsf=aac_adtstoasc --enable-bsf=h264_mp4toannexb \
--disable-devices --disable-debug --disable-ffmpeg --disable-ffprobe --disable-ffplay --disable-ffserver --disable-debug

make
make install

cd ..
