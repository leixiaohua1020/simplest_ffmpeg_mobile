cd faac
export NDK=/home/leixiaohua1020/cdtworkspace/android-ndk-r9d
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.6/prebuilt
export PLATFORM=$NDK/platforms/android-9/arch-arm
CFLAGS="-fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_7__ -Wno-psabi -march=armv7 -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID -Wa,--noexecstack -MMD -MP "
#CFLAGS="-fpic -DANDROID -fpic -mthumb-interwork -D__ARM_ARCH_7__ -Wno-psabi -march=armv7-a -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID -Wa, -MMD -MP "
CROSS_COMPILE=$PREBUILT/linux-x86_64/bin/arm-linux-androideabi-
export CPPFLAGS="$CFLAGS"
export CFLAGS="$CFLAGS"
export CXXFLAGS="$CFLAGS"
export CXX="${CROSS_COMPILE}g++ --sysroot=${PLATFORM}"
export LDFLAGS="$LDFLAGS"
export CC="${CROSS_COMPILE}gcc --sysroot=${PLATFORM}"
export NM="${CROSS_COMPILE}nm"
export STRIP="${CROSS_COMPILE}strip"
export RANLIB="${CROSS_COMPILE}ranlib"
export AR="${CROSS_COMPILE}ar"

./configure \
--without-mp4v2 \
--host=arm-linux \
--enable-static \

make
make install

#FIX
#copy files
cp -rf /usr/local/include/faac.h ../android-lib/include
cp -rf /usr/local/include/faaccfg.h ../android-lib/include
cp -rf /usr/local/lib/libfaac.a ../android-lib/lib

cd ..
