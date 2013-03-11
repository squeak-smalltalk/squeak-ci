#! /bin/sh
# This script assumes a locally installed Squeak.
# Its primary function is to allow CI to work on a CentOS box:
# recent VMs can't build on CentOS because it uses an unsupported
# glibc version.

: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

TEST_IMAGE_NAME="Squeak4.4"
IMAGE_NAME="TrunkImage"
VM="/usr/local/bin/squeak"

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$TEST_IMAGE_NAME.image" "$WORKSPACE/target/$IMAGE_NAME.image"
cp "$WORKSPACE/$TEST_IMAGE_NAME.changes" "$WORKSPACE/target/$IMAGE_NAME.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

nice $VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"
nice $VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/tests.st"