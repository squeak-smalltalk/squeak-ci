#! /bin/sh

# Run the tests for a particular package, passed in as $1.

set -e

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

PACKAGE=$1
IMAGE_NAME="TrunkImage"

fetch_cog_vm "linux"
VM=$COG_VM

echo Downloading a fresh Trunk image
mkdir -p "${SRC}/target"

CURRENT_UPDATE=`cat "${SRC}/target/TrunkImage.version"`
LATEST_UPDATE=`curl -sS ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.version`

if test "x${CURRENT_UPDATE}x" != "x${LATEST_UPDATE}x";
then
    echo Downloading Trunk version ${LATEST_UPDATE}
    curl -sSo "${SRC}/target/TrunkImage.image" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.image
    curl -sSo "${SRC}/target/TrunkImage.changes" ${BASE_URL}/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.changes
fi
test ! -f "${SRC}/target/SqueakV41.sources" && curl -sSo "${SRC}/target/SqueakV41.sources.gz" http://ftp.squeak.org/4.4/SqueakV41.sources.gz && gunzip "${SRC}/target/SqueakV41.sources.gz"
cp HudsonBuildTools.st "${SRC}/target/"

# Run the tests and snapshot the image post-test.
echo Running tests on VM ${VM}...
run_tests ${IMAGE_NAME} ${PACKAGE}