#!/bin/sh
export KERNELDIR=`readlink -f .`

export ARCH=arm

export KBUILD_BUILD_USER=SGS3_KitKat
export KBUILD_BUILD_HOST=ArchiPort

export CROSS_COMPILE=/Working_Directory/arm-cortex_a9-linux-gnueabihf-linaro_4.9.1-2014.05/bin/arm-cortex_a9-linux-gnueabihf-

if [ ! -f $KERNELDIR/.config ];
then
  make defconfig m0_00_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j2 || exit 1

mkdir -p $KERNELDIR/BUILT/lib/modules

rm $KERNELDIR/BUILT/lib/modules/*
rm $KERNELDIR/BUILT/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT/

mv .git-halt .git
