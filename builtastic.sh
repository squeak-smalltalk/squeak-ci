#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

IMAGE_NAME=Squeak4.4-trunk

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$IMAGE_NAME.image" "$WORKSPACE/target/TrunkImage.image"
cp "$WORKSPACE/$IMAGE_NAME.changes" "$WORKSPACE/target/TrunkImage.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

"$WORKSPACE/coglinux/bin/squeak" -vm-sound-null -vm-display-null "$WORKSPACE/target/TrunkImage.image" "$WORKSPACE/tests.st"

#exit 0
