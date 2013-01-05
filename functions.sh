SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"

build_cog_vm () {
    # Param:
    # $1: The name of the operating system. Currently only accepts "linux", "osx"
    if test -f $COG_VM; then
	echo Using pre-existing Cog VM at ${COG_VM}
    else
	echo Downloading Cog VM r${COG_VERSION}
	mkdir -p ${SRC}/target/cog.r${COG_VERSION}
	case $1 in
	    "linux")
		(cd ${SRC}/target/cog.r${COG_VERSION} && \
		    curl -o coglinux.tgz http://www.mirandabanda.org/files/Cog/VM/VM.r${COG_VERSION}/coglinux.tgz && \
		    tar zxvf coglinux.tgz);;
	    "freebsd")
		echo "Sadly, FreeBSD doesn't have prebuilt binaries for Cog yet" && \
		exit 1;;
	    "osx")
		(cd ${SRC}/target/cog.r${COG_VERSION} && \
		    curl -o coglinux.tgz http://www.mirandabanda.org/files/Cog/VM/VM.r${COG_VERSION}/Cog.app.tgz && \
		    tar zxvf coglinux.tgz);;
	    *) echo "Unknown OS ${1} for Cog VM. Aborting." \
		exit 1;;
	esac
    fi
}

build_interpreter_vm () {
    # Param:
    # $1: The name of the operating system. Currently only accepts "linux", "freebsd"
    if test -f $INTERPRETER_VM; then
	echo Using pre-existing interpreter VM at ${INTERPRETER_VM}
    else
	echo Downloading Interpreter VM ${INTERPRETER_VERSION}
	mkdir -p "${SRC}/target/"
	case $1 in
	    "linux" | "freebsd" | "osx")
		(cd "${SRC}/target/" && \
		    curl -o interpreter.tgz http://www.squeakvm.org/unix/release/${INTERPRETER_VERSION}-src.tar.gz && \
		    tar zxvf interpreter.tgz && \
		    cd "${SRC}/target/${INTERPRETER_VERSION}-src" && \
		    mkdir -p bld && \
		    cd bld && \
		    ../unix/cmake/configure && \
		    make);;
	    *) echo "Unknown OS ${1} for interpreter VM. Aborting." \
		exit 1;;
	esac
	if test -f $INTERPRETER_VM; then
            # Fall back to an assumed installed VM.
            # The path used in ./build-local.sh.
            INTERPRETER_VM_DIR="/usr/local/bin"
	    INTERPRETER_VM="${INTERPRETER_VM_DIR}/squeak"
	fi
    fi
}

ensure_interpreter_compatible_image() {
    # Params:
    # $1: base directory
    # $2: image name
    # $3: OS
    # Also uses env vars from versions.sh
    SRC=$1
    IMAGE_NAME=$2
    ARGS=$(vm_args $3)

    # Run the image through an interpreter VM to make sure the image format is correct.
    # Find a copy of the ckformat program, any one will do
    CKFORMAT=`find ${INTERPRETER_VM_DIR} -name ckformat | head -1`
    if test -x "$CKFORMAT"; then
	echo before format conversion: "${SRC}/target/$IMAGE_NAME.image" image format `${CKFORMAT} "${SRC}/target/$IMAGE_NAME.image"`
    else
	echo WARNING: no ckformat found
    fi

    if test -f $INTERPRETER_VM; then
	$INTERPRETER_VM ${ARGS} "${SRC}/target/$IMAGE_NAME.image" "${SRC}/save-image.st"
    else
	echo WARNING: $INTERPRETER_VM not found, image not converted to format 6504
    fi

    if test -x "$CKFORMAT"; then
	echo after format conversion: "${SRC}/target/$IMAGE_NAME.image" image format `${CKFORMAT} "${SRC}/target/$IMAGE_NAME.image"`
    fi
}

prepare_target () {
    echo Preparing target...
    # Params:
    # $1: base directory
    # $2: source file name prefix
    # $3: target file name prefix
    mkdir -p ${1}/target/
    cp ${1}/${2}.image ${1}/target/${3}.image
    cp ${1}/${2}.changes ${1}/target/${3}.changes
    cp ${1}/SqueakV41.sources ${1}/target/SqueakV41.sources
    cp ${1}/HudsonBuildTools.st ${1}/target/HudsonBuildTools.st
}

update_image() {
    # Params:
    # $1: base directory
    # $2: VM path
    # $3: OS
    WORKSPACE=$1
    VM=$2
    ARGS=$(vm_args $3)
    ${VM} ${ARGS} "${WORKSPACE}/target/$IMAGE_NAME.image" "${WORKSPACE}/update-image.st"
    echo Updated to update number `cat ${WORKSPACE}/target/TrunkImage.version`
}

vm_args() {
    # Params:
    # $1: OS
   local ARGS="-vm-sound-null -vm-display-null"
   case $1 in
	"osx")
	    ARGS="-headless";;
	*)
	    ARGS="-vm-sound-null -vm-display-null";;
    esac
   echo $ARGS
}