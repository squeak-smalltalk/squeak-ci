#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

TEST_IMAGE_NAME="Squeak4.4-trunk"
IMAGE_NAME="TrunkImage"
RUN_TEST_IMAGE_NAME="PostTestTrunkImage"
VM="$WORKSPACE/coglinux/bin/squeak"
INTERPRETER_VM="/usr/local/bin/squeak" # The path used in ./build-local.sh

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$TEST_IMAGE_NAME.image" "$WORKSPACE/target/$IMAGE_NAME.image"
cp "$WORKSPACE/$TEST_IMAGE_NAME.changes" "$WORKSPACE/target/$IMAGE_NAME.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

# Update the image
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"

# Run the image through an interpreter VM to make sure the image format is correct.

if [-f $INTERPRETER_VM]; then
  $INTERPRETER_VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/save-image.st"
fi

# Copy the clean image so we can run the tests without touching the artifact.
cp "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/target/$RUN_TEST_IMAGE_NAME.image"
cp "$WORKSPACE/target/$IMAGE_NAME.changes" "$WORKSPACE/target/$RUN_TEST_IMAGE_NAME.changes"

# Run the tests and snapshot the image post-test.
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$RUN_TEST_IMAGE_NAME.image" "$WORKSPACE/tests.st"
