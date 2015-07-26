#!/bin/sh
# LXH,MXY modified

cd ./ffmpeg

INSTALL="thin-ffmpeg"

# libx264
export X264ROOT=../thin-x264/x86_64
export X264LIB=$X264ROOT/lib
export X264INCLUDE=$X264ROOT/include
# libfaac
export FAACROOT=../thin-faac/x86_64
export FAACLIB=$FAACROOT/lib
export FAACINCLUDE=$FAACROOT/include

unset DEVROOT
unset SDKROOT
unset CC
unset LD
unset CXX
unset LIBTOOL
unset HOST
unset LDFLAGS
unset CFLAGS

echo "Building x86_64..."

make clean
./configure \
    --extra-cflags='-I$X264INCLUDE -I$FAACINCLUDE' \
    --extra-ldflags='-L$X264LIB -L$FAACLIB' \
    --disable-iconv \
    --disable-asm \
--prefix=../${INSTALL}/x86_64 \
--enable-gpl --enable-nonfree --enable-version3 --disable-bzlib --enable-small --disable-vda \
--disable-encoders --enable-libx264 --enable-libfaac --enable-encoder=libx264 --enable-encoder=mpeg2video --enable-encoder=libfaac \
--disable-muxers --enable-muxer=flv --enable-muxer=mov --enable-muxer=ipod --enable-muxer=mpegts --enable-muxer=psp --enable-muxer=mp4 --enable-muxer=avi \
--disable-decoders --enable-decoder=aac --enable-decoder=mpeg2video --enable-decoder=aac_latm --enable-decoder=h264 --enable-decoder=mpeg4 \
--disable-demuxers --enable-demuxer=flv --enable-demuxer=h264 --enable-demuxer=avi --enable-demuxer=mpegts --enable-demuxer=mpc --enable-demuxer=mov \
--disable-parsers --enable-parser=aac --enable-parser=ac3 --enable-parser=h264 \
--disable-protocols --enable-protocol=file --enable-protocol=rtmp --enable-protocol=rtp --enable-protocol=udp \
--enable-bsf=aac_adtstoasc --enable-bsf=h264_mp4toannexb \
--disable-devices --disable-debug --disable-ffmpeg --disable-ffprobe --disable-ffplay --disable-ffserver --disable-debug

make
make install
make clean
cd ..