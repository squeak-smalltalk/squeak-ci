#! /bin/sh

# Assume that something's copied the source tarball to this directory.

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

TARBALL=`find . -name Squeak-vm-unix-*.tar.gz | head -1`
tar zxvf $TARBALL
SRC=`find . -name Squeak-vm-unix-*-src | head -1`
cd $SRC
mkdir -p bld
cd bld
../unix/cmake/configure
make