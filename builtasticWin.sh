#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

TEST_IMAGE_NAME="Squeak4.4"
IMAGE_NAME="TrunkImage"
VM="$WORKSPACE/cogwin/Croquet.exe"

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$TEST_IMAGE_NAME.image" "$WORKSPACE/target/$IMAGE_NAME.image"
cp "$WORKSPACE/$TEST_IMAGE_NAME.changes" "$WORKSPACE/target/$IMAGE_NAME.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

$VM -headless "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"
$VM -headless "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/tests.st"
