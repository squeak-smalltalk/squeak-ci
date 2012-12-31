#! /bin/sh

# This script takes the output of builtastic.sh and creates a releasable
# artifact.

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

curl -o "${SRC}/target/TrunkImage.image" http://squeakci.org/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.image
curl -o "${SRC}/target/TrunkImage.changes" http://squeakci.org/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.changes
curl -o "${SRC}/target/TrunkImage.version" http://squeakci.org/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.version

SQUEAK_VERSION=`cat ${SRC}/target/TrunkImage.version`
BASENAME=Squeak4.4-${SQUEAK_VERSION}

build_interpreter_vm "linux"

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
rm ${SRC}/target/*.zip
(cd ${SRC}/target; zip -j ${BASENAME}.zip ${BASENAME}.changes ${BASENAME}.image)