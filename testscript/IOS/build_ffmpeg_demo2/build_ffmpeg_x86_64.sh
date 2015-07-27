#!/bin/sh

cd ./ffmpeg


export INSTALL=thin-ffmpeg
#change the below line to point to the where libx264 is
export X264ROOT=../thin-x264/x86_64
export X264LIB=$X264ROOT/lib
export X264INCLUDE=$X264ROOT/include

export FAACROOT=../thin-faac/x86_64
export FAACLIB=$FAACROOT/lib
export FAACINCLUDE=$FAACROOT/include


echo "Building x86_64..."
make clean
./configure \
    --extra-cflags='-I$X264INCLUDE -I$FAACINCLUDE' \
    --extra-ldflags='-L$X264LIB -L$FAACLIB ' \
    --disable-iconv\
    --disable-asm \
--prefix=../${INSTALL}/x86_64 \
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
