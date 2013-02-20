#! /bin/sh

# Assume that something's copied the source tarball to this directory.

set -e

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

mkdir -p "${SRC}/target"
TARBALL=`find . -name Squeak-vm-unix-*.tar.gz | sort -r | head -1`
if test "x${TARBALL}x" == "xx"; then
    echo "Missing tarball!" && exit 1
fi
mv $TARBALL "${SRC}/target/${TARBALL}"
(cd "${SRC}/target/"; tar zxvf ${TARBALL})
SOURCE=`find target -name Squeak-vm-unix-*-src | sort -r | head -1`
(cd $SOURCE/unixbuild/bld && \
  ../../platforms/unix/config/configure --without-npsqueak CFLAGS="-g -O2 -msse2 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -DNDEBUG -DITIMER_HEARTBEAT=1 -DNO_VM_PROFILE=1 -DCOGMTVM=0 -DDEBUGVM=0 -m32" LIBS=-lpthread && \
  make install "${SRC}/target/vm/")