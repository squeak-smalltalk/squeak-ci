#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

IMAGE_NAME=Squeak4.4-11925

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$IMAGE_NAME.image" "$WORKSPACE/target/ImageUnderTest.image"
cp "$WORKSPACE/$IMAGE_NAME.changes" "$WORKSPACE/target/ImageUnderTest.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"

"$WORKSPACE/coglinux/bin/squeak" "$WORKSPACE/target/ImageUnderTest.image" "$WORKSPACE/tests.st"

exit 0
