#!/bin/sh

cd ./ffmpeg

export PLATFORM="iPhoneSimulator"

export INSTALL=thin-ffmpeg
#change the below line to point to the where libx264 is
export X264ROOT=../thin-x264/i386
export X264LIB=$X264ROOT/lib
export X264INCLUDE=$X264ROOT/include
export FAACROOT=../thin-faac/i386
export FAACLIB=$FAACROOT/lib
export FAACINCLUDE=$FAACROOT/include

export DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer
export SDKROOT=$DEVROOT/SDKs/${PLATFORM}8.3.sdk
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
    --arch=i386 --disable-iconv\
    --target-os=darwin \
    --cc=${CC} \
    --sysroot=${SDKROOT} \
    --prefix=../${INSTALL}/i386 \
--enable-gpl --enable-nonfree --enable-version3 --disable-bzlib --enable-small\
 --disable-encoders --enable-libx264 --enable-libfaac --enable-encoder=libx264 --enable-encoder=libfaac\
 --disable-muxers --enable-muxer=mov --enable-muxer=ipod --enable-muxer=psp --enable-muxer=mp4 --enable-muxer=avi\
 --disable-decoders --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=h264 --enable-decoder=mpeg4\
 --disable-demuxers --enable-demuxer=h264 --enable-demuxer=avi --enable-demuxer=mpc --enable-demuxer=mov\
 --disable-parsers --enable-parser=aac --enable-parser=ac3 --enable-parser=h264\
 --disable-protocols --disable-filter=spp --enable-protocol=file\
 --disable-bsfs --enable-bsf=aac_adtstoasc --enable-bsf=h264_mp4toannexb\
 --disable-indevs\
 --disable-outdevs --disable-ffprobe --disable-ffplay --disable-ffserver --disable-debug

make
make install

cd ..

