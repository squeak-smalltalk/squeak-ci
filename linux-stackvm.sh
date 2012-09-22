#!/bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

TEST_IMAGE_NAME=Squeak4.4-trunk
IMAGE_NAME="StackVM-TrunkImage"
VM="$WORKSPACE/target/linux-stackvm/bin/squeak"

mkdir -p "$WORKSPACE/target/"
wget -O target/Squeak-4.10.2.2614-linux_x86_64.sh http://www.squeakvm.org/unix/release/Squeak-4.10.2.2614-linux_x86_64.sh
chmod +x target/Squeak-4.10.2.2614-linux_x86_64.sh
cd target
mkdir -p linux-stackvm
./Squeak-4.10.2.2614-linux_x86_64.sh -prefix=linux-stackvm

cp "$WORKSPACE/$TEST_IMAGE_NAME.image" "$WORKSPACE/target/$IMAGE_NAME.image"
cp "$WORKSPACE/$TEST_IMAGE_NAME.changes" "$WORKSPACE/target/$IMAGE_NAME.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/tests.st"