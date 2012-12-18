#! /bin/sh

COG_VERSION=2636


: ${WORKSPACE:=`pwd`} # Default to the current directory to ease testing
TEST_IMAGE_NAME="Squeak4.4-trunk"
IMAGE_NAME="TrunkImage"
RUN_TEST_IMAGE_NAME="PostTestTrunkImage"
VM="$WORKSPACE/cog.r${COG_VERSION}/coglinux/bin/squeak"
INTERPRETER_VM="/usr/local/bin/squeak" # The path used in ./build-local.sh

if test -f $VM; then
  echo "Using pre-existing Cog VM at $VM"
else
  echo Downloading Cog VM r${COG_VERSION}
  mkdir -p cog.r${COG_VERSION}
  (cd cog.r${COG_VERSION} && \
    curl -o coglinux.tgz http://www.mirandabanda.org/files/Cog/VM/VM.r${COG_VERSION}/coglinux.tgz && \
    tar zxvf coglinux.tgz)
fi

mkdir -p "$WORKSPACE/target/"
cp "$WORKSPACE/$TEST_IMAGE_NAME.image" "$WORKSPACE/target/$IMAGE_NAME.image"
cp "$WORKSPACE/$TEST_IMAGE_NAME.changes" "$WORKSPACE/target/$IMAGE_NAME.changes"
cp "$WORKSPACE/SqueakV41.sources" "$WORKSPACE/target/SqueakV41.sources"
cp "$WORKSPACE/HudsonBuildTools.st" "$WORKSPACE/target/HudsonBuildTools.st"

# Update the image
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/update-image.st"

# Run the image through an interpreter VM to make sure the image format is correct.

# Find a copy of the ckformat program, any one will do
CKFORMAT=`find /usr/local/lib/squeak -name ckformat | head -1`

if test -x "$CKFORMAT"; then
 echo before format conversion: "$WORKSPACE/target/$IMAGE_NAME.image" image format `${CKFORMAT} "$WORKSPACE/target/$IMAGE_NAME.image"`
else
 echo WARNING: no ckformat found
fi

if test -f $INTERPRETER_VM; then
 $INTERPRETER_VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/save-image.st"
else
 echo WARNING: $INTERPRETER_VM not found, image not converted to format 6504
fi

if test -x "$CKFORMAT"; then
 echo after format conversion: "$WORKSPACE/target/$IMAGE_NAME.image" image format `${CKFORMAT} "$WORKSPACE/target/$IMAGE_NAME.image"`
fi

# Copy the clean image so we can run the tests without touching the artifact.
cp "$WORKSPACE/target/$IMAGE_NAME.image" "$WORKSPACE/target/$RUN_TEST_IMAGE_NAME.image"
cp "$WORKSPACE/target/$IMAGE_NAME.changes" "$WORKSPACE/target/$RUN_TEST_IMAGE_NAME.changes"

# Run the tests and snapshot the image post-test.
$VM -vm-sound-null -vm-display-null "$WORKSPACE/target/$RUN_TEST_IMAGE_NAME.image" "$WORKSPACE/tests.st"
