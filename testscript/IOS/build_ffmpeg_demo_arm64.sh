#!/bin/sh
# LXH,MXY modified

cd ffmpeg

PLATFORM="iPhoneOS"
INSTALL="thin-ffmpeg"
SDK_VERSION="8.3"

# libx264
export X264ROOT=../thin-x264/arm64
export X264LIB=$X264ROOT/lib
export X264INCLUDE=$X264ROOT/include
# libfaac
export FAACROOT=../thin-faac/arm64
export FAACLIB=$FAACROOT/lib
export FAACINCLUDE=$FAACROOT/include

export DEVROOT=/Applications/Xcode.app/Contents/Developer

export SDKROOT=$DEVROOT/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDK_VERSION}.sdk
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
--enable-gpl --enable-nonfree --enable-version3 --disable-bzlib --enable-small --disable-vda \
--disable-encoders --enable-libx264 --enable-libfaac --enable-encoder=libx264 --enable-encoder=libfaac \
--disable-muxers --enable-muxer=flv --enable-muxer=mov --enable-muxer=ipod --enable-muxer=mpegts --enable-muxer=psp --enable-muxer=mp4 --enable-muxer=avi \
--disable-decoders --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=h264 --enable-decoder=mpeg4 \
--disable-demuxers --enable-demuxer=flv --enable-demuxer=h264 --enable-demuxer=avi --enable-demuxer=mpegts --enable-demuxer=mpc --enable-demuxer=mov \
--disable-parsers --enable-parser=aac --enable-parser=ac3 --enable-parser=h264 \
--disable-protocols --enable-protocol=file --enable-protocol=rtmp --enable-protocol=rtp --enable-protocol=udp \
--disable-bsfs --enable-bsf=aac_adtstoasc --enable-bsf=h264_mp4toannexb \
--disable-devices --disable-debug --disable-ffmpeg --disable-ffprobe --disable-ffplay --disable-ffserver --disable-debug

make
make install

cd ..