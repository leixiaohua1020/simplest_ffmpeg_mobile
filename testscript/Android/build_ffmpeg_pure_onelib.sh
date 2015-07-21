cd ffmpeg

make clean

export NDK=/home/leixiaohua1020/cdtworkspace/android-ndk-r9d
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt
export PLATFORM=$NDK/platforms/android-8/arch-arm
export PREFIX=../ff-pure-onelib
build_one(){
  ./configure --target-os=linux --prefix=$PREFIX \
--enable-cross-compile \
--enable-runtime-cpudetect \
--disable-asm \
--arch=arm \
--cc=$PREBUILT/linux-x86_64/bin/arm-linux-androideabi-gcc \
--cross-prefix=$PREBUILT/linux-x86_64/bin/arm-linux-androideabi- \
--disable-stripping \
--nm=$PREBUILT/linux-x86_64/bin/arm-linux-androideabi-nm \
--sysroot=$PLATFORM \
--enable-gpl --enable-static --disable-shared --enable-nonfree --enable-version3 --enable-small \
--enable-zlib --disable-ffprobe --disable-ffplay --disable-ffmpeg --disable-ffserver --disable-debug \
--extra-cflags="-fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a" 
}

build_one

make
make install

$PREBUILT/linux-x86_64/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavfilter/libavfilter.a libswresample/libswresample.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a libpostproc/libpostproc.a libavdevice/libavdevice.a -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $PREBUILT/linux-x86_64/lib/gcc/arm-linux-androideabi/4.8/libgcc.a

cd ..
