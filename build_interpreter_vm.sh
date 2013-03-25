#! /bin/sh

# Assume that something's copied the source tarball to this directory.

set -e

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

mkdir -p "${SRC}/target"
curl -sSo "${SRC}/target/archive.zip" ${BASE_URL}/job/InterpreterVM/lastSuccessfulBuild/artifact/*zip*/archive.zip
cd "${SRC}/target/"
unzip -o archive.zip
mv archive/* .
TARBALL=`find . -name 'Squeak-vm-unix-*-src*.tar.gz' | grep -v Cog | head -1`
tar zxf ${TARBALL}
SOURCE=`find . -name 'Squeak-vm-unix-*-src' | grep -v Cog | head -1`
mv $SOURCE $SOURCE-32
(cd $SOURCE-32/platforms/unix; make)