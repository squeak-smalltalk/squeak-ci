#! /bin/sh

# This script takes the output of builtastic.sh and creates a releasable
# artifact.

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

SQUEAK_VERSION=`cat ${SRC}/target/TrunkImage.version`
BASENAME=Squeak4.4-${SQUEAK_VERSION}

build_interpreter_vm

echo Using ${INTERPRETER_VM}
echo Preparing ${BASENAME}...
cp ${SRC}/target/TrunkImage.changes ${SRC}/target/${BASENAME}.changes
cp ${SRC}/target/TrunkImage.image ${SRC}/target/${BASENAME}.image

chmod +w ${SRC}/target/${BASENAME}.changes
chmod +w ${SRC}/target/${BASENAME}.image

echo Releasing ${BASENAME}...
${INTERPRETER_VM} -vm-sound-null -vm-display-null ${SRC}/target/${BASENAME}.image ${SRC}/release.st

echo Zipping ${BASENAME}...
# Previous runs might leave a zip lying around.
rm ${BASENAME}.zip
(cd ${SRC}/target; zip -j ${BASENAME}.zip ${BASENAME}.changes ${BASENAME}.image)