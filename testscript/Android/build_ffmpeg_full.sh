cd ffmpeg

make clean

export NDK=/home/leixiaohua1020/cdtworkspace/android-ndk-r9d
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.6/prebuilt
export PLATFORM=$NDK/platforms/android-8/arch-arm
export PREFIX=../ff-full
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
--enable-gpl --enable-shared --disable-static --enable-nonfree --enable-version3 --enable-small --disable-vda --disable-iconv \
--enable-libx264 --enable-libfaac --enable-encoder=libx264 --enable-encoder=libfaac \
--enable-zlib --disable-ffprobe --disable-ffplay --disable-ffmpeg --disable-ffserver --disable-debug \
--extra-cflags="-I ../android-lib/include -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a" \
--extra-ldflags="-L ../android-lib/lib"

}

build_one

make
make install

cd ..
