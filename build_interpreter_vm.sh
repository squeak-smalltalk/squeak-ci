#! /bin/sh

# Assume that something's copied the source tarball to this directory.

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

mkdir -p "${SRC}/target"
TARBALL=`find . -name Squeak-vm-unix-*.tar.gz | head -1`
mv $TARBALL "${SRC}/target/${TARBALL}"
tar zxvf "${SRC}/target/${TARBALL}"
SOURCE=`find target -name Squeak-vm-unix-*-src | head -1`
(cd $SOURCE/platforms/unix; make)