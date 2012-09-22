#!/bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

TEST_IMAGE_NAME=Squeak4.4-trunk
IMAGE_NAME="StackVM-TrunkImage"
VM="$WORKSPACE/target/linux-stackvm/bin/squeak"

mkdir -p "$WORKSPACE/target/"
wget -O "$WORKSPACE/target/Squeak-4.10.2.2614-linux_i386.sh" http://www.squeakvm.org/unix/release/Squeak-4.10.2.2614-linux_i386.sh
chmod +x "$WORKSPACE/target/Squeak-4.10.2.2614-linux_i386.sh"
mkdir -p "$WORKSPACE/target/linux-stackvm"
"$WORKSPACE/target/Squeak-4.10.2.2614-linux_i386.sh" -prefix="$WORKSPACE/target/linux-stackvm"

cp "$WORKSPACE/$TEST_IMAGE_NAME.image" "$WORKSPACE/target/$IMAGE_NAME.image"
cp "$WORKSPACE/$TEST_IMAGE_NAME.changes" "$WORKSPACE/target/$IMAGE_NAME.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/tests.st"