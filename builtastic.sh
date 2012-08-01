#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

mkdir $WORKSPACE/target/
cp $WORKSPACE/Squeak4.4-12053.image $WORKSPACE/target/ImageUnderTest.image
cp $WORKSPACE/Squeak4.4-12053.changes $WORKSPACE/target/ImageUnderTest.changes

$WORKSPACE/coglinux/bin/squeak -headless $WORKSPACE/target/ImageUnderTest.image $WORKSPACE/tests.st

exit 0
