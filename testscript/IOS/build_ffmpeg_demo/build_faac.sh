#!/bin/sh
cd ./faac
make distclean
cd ..

CONFIGURE_FLAGS="--enable-static --with-pic"

ARCHS="arm64 armv7s x86_64 i386 armv7"

# directories
SOURCE="faac"
FAT="fat-faac"

SCRATCH="scratch-faac"
# must be an absolute path
THIN=`pwd`/"thin-faac"

COMPILE="y"
LIPO="y"

if [ "$*" ]
then
if [ "$*" = "lipo" ]
then
# skip compile
COMPILE=
else
ARCHS="$*"
if [ $# -eq 1 ]
then
# skip lipo
LIPO=
fi
fi
fi

if [ "$COMPILE" ]
then
CWD=`pwd`
for ARCH in $ARCHS
do
echo "building $ARCH..."
mkdir -p "$SCRATCH/$ARCH"
cd "$SCRATCH/$ARCH"

if [ "$ARCH" = "i386" -o "$ARCH" = "x86_64" ]
then
PLATFORM="iPhoneSimulator"
CPU=
if [ "$ARCH" = "x86_64" ]
then
SIMULATOR="-mios-simulator-version-min=7.0"
HOST=
else
SIMULATOR="-mios-simulator-version-min=5.0"
HOST="--host=i386-apple-darwin"
fi
else
PLATFORM="iPhoneOS"
if [ $ARCH = "armv7s" ]
then
CPU="--cpu=swift"
else
CPU=
fi
SIMULATOR=
HOST="--host=arm-apple-darwin"
fi

XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
CC="xcrun -sdk $XCRUN_SDK clang -Wno-error=unused-command-line-argument-hard-error-in-future"
AS="/usr/local/bin/gas-preprocessor.pl $CC"
CFLAGS="-arch $ARCH $SIMULATOR"
CXXFLAGS="$CFLAGS"
LDFLAGS="$CFLAGS"

CC=$CC CFLAGS=$CXXFLAGS LDFLAGS=$LDFLAGS CPPFLAGS=$CXXFLAGS CXX=$CC CXXFLAGS=$CXXFLAGS  $CWD/$SOURCE/configure \
$CONFIGURE_FLAGS \
$HOST \
--prefix="$THIN/$ARCH" \
--disable-shared \
--without-mp4v2

make clean && make && make install-strip
cd $CWD
done
fi

#================ fat lib ===================

echo "building fat binaries..."
mkdir -p $FAT/lib
set - $ARCHS
CWD=`pwd`
cd $THIN/$1/lib
for LIB in *.a
do
cd $CWD
lipo -create `find $THIN -name $LIB` -output $FAT/lib/$LIB
done

cd $CWD
cp -rf $THIN/$1/include $FAT






