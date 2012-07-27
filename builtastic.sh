#! /bin/sh
: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing

$WORKSPACE/coglinux/bin/squeak -headless $WORKSPACE/Squeak4.4-12053.image $WORKSPACE/tests.st

exit 0
