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

$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/tests.st"