#! /bin/sh

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

TEST_IMAGE_NAME="Squeak4.4"
IMAGE_NAME="TrunkImage"
RUN_TEST_IMAGE_NAME="PostTestTrunkImage"

fetch_cog_vm "osx"
build_interpreter_vm "osx"
prepare_target ${SRC} $TEST_IMAGE_NAME $IMAGE_NAME
VM="${SRC}/target/cog.r${COG_VERSION}/Cog.app/Contents/MacOS/Croquet"

# Update the image, and record the update number in target/TrunkImage.version
echo Updating target image...
update_image ${SRC} ${VM} "osx"
#ensure_interpreter_compatible_image ${SRC} ${IMAGE_NAME}

# Copy the clean image so we can run the tests without touching the artifact.
cp "${SRC}/target/$IMAGE_NAME.image" "${SRC}/target/$RUN_TEST_IMAGE_NAME.image"
cp "${SRC}/target/$IMAGE_NAME.changes" "${SRC}/target/$RUN_TEST_IMAGE_NAME.changes"

# Run the tests and snapshot the image post-test.
echo Running tests on VM ${VM}...
ARGS=$(vm_args "osx")
echo $VM ${ARGS} -version
nice $VM ${ARGS} -reportheadroom "${SRC}/target/$RUN_TEST_IMAGE_NAME.image" "${SRC}/tests.st"