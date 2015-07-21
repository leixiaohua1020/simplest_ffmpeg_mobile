cd x264
export NDK=/home/leixiaohua1020/cdtworkspace/android-ndk-r9d
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.6/prebuilt
export PLATFORM=$NDK/platforms/android-8/arch-arm
export PREFIX=../android-lib
./configure --prefix=$PREFIX \
--enable-static \
--enable-pic \
--disable-asm \
--disable-cli \
--host=arm-linux \
--cross-prefix=$PREBUILT/linux-x86_64/bin/arm-linux-androideabi- \
--sysroot=$PLATFORM

make 
make install

cd ..
