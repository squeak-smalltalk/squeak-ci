#! /bin/sh

# Run Trunk tests on a Trunk image running on top of a bleeding-edge Cog VM.
# Assumes the existence of something named like Squeak-vm-unix-*-unofficial-src-*.tar.gz

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

TEST_IMAGE_NAME="Squeak4.4-trunk"
IMAGE_NAME="TrunkImage"
COG_PATTERN="Squeak-vm-unix-*-unofficial-src"

prepare_target ${SRC} $TEST_IMAGE_NAME $IMAGE_NAME

curl -o "${SRC}/target/${IMAGE_NAME}.image" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.image
curl -o "${SRC}/target/${IMAGE_NAME}.changes" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.changes
curl -o "${SRC}/target/${IMAGE_NAME}.version" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.version

SQUEAK_UPDATE_NUMBER=`cat ${SRC}/target/TrunkImage.version`
BASENAME=${SQUEAK_VERSION}-${SQUEAK_UPDATE_NUMBER}
VM_TARBALL=`find target -name ${COG_PATTERN}-*.tar.gz | head -1`
#VM_VERSION=`find target -name ${COG_PATTERN} | head -1`
VM_VERSION="(whatever version Cog the CogVM build spits out)"

#echo Unpacking Cog source...
#(cd target; tar zxvf $VM_TARBALL)

#VM="${SRC}/target/${VM_BASE}"
VM=/var/lib/jenkins/workspace/CogVM/tmp/squeak

echo Running ${BASENAME} tests on Cog ${VM_VERSION}...
$VM -vm-sound-null -vm-display-null "${SRC}/target/$IMAGE_NAME.image" "${SRC}/tests.st"
