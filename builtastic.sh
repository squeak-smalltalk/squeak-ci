#! /bin/sh

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

# : ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing
TEST_IMAGE_NAME="Squeak4.4-trunk"
IMAGE_NAME="TrunkImage"
RUN_TEST_IMAGE_NAME="PostTestTrunkImage"

build_cog_vm "linux"
build_interpreter_vm "linux"
prepare_target ${SRC} $TEST_IMAGE_NAME $IMAGE_NAME

# Update the image
echo Updating target image...
$INTERPRETER_VM -vm-sound-null -vm-display-null "${SRC}/target/$IMAGE_NAME.image" "${SRC}/update-image.st"
echo Updated to update number `cat target/TrunkImage.version`

# Run the image through an interpreter VM to make sure the image format is correct.
# Find a copy of the ckformat program, any one will do
CKFORMAT=`find ${INTERPRETER_VM_DIR} -name ckformat | head -1`
if test -x "$CKFORMAT"; then
 echo before format conversion: "${SRC}/target/$IMAGE_NAME.image" image format `${CKFORMAT} "${SRC}/target/$IMAGE_NAME.image"`
else
 echo WARNING: no ckformat found
fi

if test -f $INTERPRETER_VM; then
 $INTERPRETER_VM -vm-sound-null -vm-display-null "${SRC}/target/$IMAGE_NAME.image" "${SRC}/save-image.st"
else
 echo WARNING: $INTERPRETER_VM not found, image not converted to format 6504
fi

if test -x "$CKFORMAT"; then
 echo after format conversion: "${SRC}/target/$IMAGE_NAME.image" image format `${CKFORMAT} "${SRC}/target/$IMAGE_NAME.image"`
fi

# Copy the clean image so we can run the tests without touching the artifact.
cp "${SRC}/target/$IMAGE_NAME.image" "${SRC}/target/$RUN_TEST_IMAGE_NAME.image"
cp "${SRC}/target/$IMAGE_NAME.changes" "${SRC}/target/$RUN_TEST_IMAGE_NAME.changes"

# Run the tests and snapshot the image post-test.
echo Running tests on VM ${COG_VM}...
$COG_VM -vm-sound-null -vm-display-null "${SRC}/target/$RUN_TEST_IMAGE_NAME.image" "${SRC}/tests.st"
