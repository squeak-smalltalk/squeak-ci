#! /bin/sh

# This script takes the output of builtastic.sh and creates a releasable
# artifact.

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

echo Downloading a fresh Trunk image
curl -sSo "${SRC}/target/TrunkImage.image" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.image
curl -sSo "${SRC}/target/TrunkImage.changes" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.changes
curl -sSo "${SRC}/target/TrunkImage.version" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.version

SQUEAK_UPDATE_NUMBER=`cat ${SRC}/target/TrunkImage.version`
echo Downloaded Trunk updated to ${SQUEAK_UPDATE_NUMBER}
BASENAME=${SQUEAK_VERSION}-${SQUEAK_UPDATE_NUMBER}

build_interpreter_vm "linux"

echo Using ${INTERPRETER_VM}
echo Preparing ${BASENAME}...
cp ${SRC}/target/TrunkImage.changes ${SRC}/target/${BASENAME}.changes
cp ${SRC}/target/TrunkImage.image ${SRC}/target/${BASENAME}.image

chmod +w ${SRC}/target/${BASENAME}.changes
chmod +w ${SRC}/target/${BASENAME}.image

echo Releasing ${BASENAME}...
nice ${INTERPRETER_VM} -vm-sound-null -vm-display-null ${SRC}/target/${BASENAME}.image ${SRC}/release.st

echo Zipping ${BASENAME}...
# Previous runs might leave a zip lying around.
rm ${SRC}/target/*.zip
rm ${SRC}/target/*.tgz
(cd ${SRC}/target; \
  zip -j ${BASENAME}.zip ${BASENAME}.changes ${BASENAME}.image; \
  tar zcvf ${BASENAME}.tgz ${BASENAME}.changes ${BASENAME}.image)