#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

LAST_RELEASED_IMAGE_NAME=Squeak4.3

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$LAST_RELEASED_IMAGE_NAME.image" "$WORKSPACE/target/UpdatedFromLastReleaseImage.image"
cp "$WORKSPACE/$LAST_RELEASED_IMAGE_NAME.changes" "$WORKSPACE/target/UpdatedFromLastReleaseImage.changes"

cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

"$WORKSPACE/coglinux/bin/squeak" -vm-sound-null -vm-display-null "$WORKSPACE/target/UpdatedFromLastReleaseImage.image" "$WORKSPACE/update-image.st" "$WORKSPACE/tests.st"