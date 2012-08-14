#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

LAST_RELEASED_IMAGE_NAME=Squeak4.3
IMAGE_NAME="UpdatedFromLastReleaseImage"
VM="$WORKSPACE/coglinux/bin/squeak"

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$LAST_RELEASED_IMAGE_NAME.image" "$WORKSPACE/target/$IMAGE_NAME.image"
cp "$WORKSPACE/$LAST_RELEASED_IMAGE_NAME.changes" "$WORKSPACE/target/$IMAGE_NAME.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

# Update the image
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"

# Copy the CLEAN image to TestImage
cp "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/target/TestImage.image"
cp "$WORKSPACE/target/$IMAGE_NAME.changes" "$WORKSPACE/target/TestImage.changes"

# Keep the dirt caused by running tests away from the pristine image.
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/TestImage.image" "$WORKSPACE/tests.st"