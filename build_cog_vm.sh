#! /bin/sh

set -e

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

mkdir -p "${SRC}/target"
curl -sSo "${SRC}/target/archive.zip" http://build.squeak.org/job/CogVM/lastSuccessfulBuild/artifact/*zip*/archive.zip
(cd "${SRC}/target/"; unzip -o archive.zip)
TARBALL=`find . -name Squeak-vm-unix-*.tar.gz | sort -r | head -1`
tar zxf ${TARBALL}
SOURCE=`find . -name Squeak-vm-unix-*-src | sort -r | head -1`
mv "${SOURCE}" "${SRC}/target/${SOURCE}"
(cd ${SRC}/target/${SOURCE}/unixbuild/bld && \
  ../../platforms/unix/config/configure --without-npsqueak CFLAGS="-g -O2 -msse2 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -DNDEBUG -DITIMER_HEARTBEAT=1 -DNO_VM_PROFILE=1 -DCOGMTVM=0 -DDEBUGVM=0 -m32" LIBS=-lpthread && \
  make install "${SRC}/target/vm/")