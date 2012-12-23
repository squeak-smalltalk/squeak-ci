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
# -vm-sound-null -vm-display-null
${INTERPRETER_VM}  ${SRC}/target/${BASENAME}.image ../release-4.4.st

echo Zipping ${BASENAME}...
zip ${SRC}/target/${BASENAME}.zip ${SRC}/target/${BASENAME}.changes ${SRC}/target/${BASENAME}.image