SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"

fetch_cog_vm () {
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
		    curl -sSo coglinux.tgz http://www.mirandabanda.org/files/Cog/VM/VM.r${COG_VERSION}/coglinux-${COG_TIMESTAMP}.${COG_VERSION}.tgz && \
		    tar zxf coglinux.tgz);;
	    "freebsd")
		echo "Sadly, FreeBSD doesn't have prebuilt binaries for Cog yet" && \
		exit 1;;
	    "osx")
		(cd ${SRC}/target/cog.r${COG_VERSION} && \
		    curl -sSo Cog.app.tgz http://www.mirandabanda.org/files/Cog/VM/VM.r${COG_VERSION}/Cog.app-${COG_TIMESTAMP}.${COG_VERSION}.tgz && \
		    tar zxf Cog.app.tgz);;
	    *) echo "Unknown OS ${1} for Cog VM. Aborting." && \
		exit 1;;
	esac
    fi
}

build_interpreter_vm () {
    # Param:
    # $1: The name of the operating system. Currently only accepts "linux", "freebsd"
    # $2: "32" or "64" (defaulting to "32")
    local W=$2
    WIDTH=${W:-32}
    echo Checking for "${SRC}/target/${INTERPRETER_VERSION}-src-${WIDTH}"
    if test -d ${SRC}/target/${INTERPRETER_VERSION}-src-${WIDTH}; then
	echo Using pre-existing interpreter VM in ${SRC}/target/${INTERPRETER_VERSION}-src-${WIDTH}
    else
	echo Downloading Interpreter VM ${INTERPRETER_VERSION}
	mkdir -p "${SRC}/target/"
	case $1 in
	    "linux" | "freebsd" | "osx")
		(cd "${SRC}/target/" && \
		    curl -sSo interpreter.tgz http://www.squeakvm.org/unix/release/${INTERPRETER_VERSION}-src.tar.gz && \
		    tar zxf interpreter.tgz && \
		    rm -rf "${SRC}/target/${INTERPRETER_VERSION}-src-${WIDTH}" && \
		    mv "${SRC}/target/${INTERPRETER_VERSION}-src" "${SRC}/target/${INTERPRETER_VERSION}-src-${WIDTH}" && \
		    cd "${SRC}/target/${INTERPRETER_VERSION}-src-${WIDTH}" && \
		    mkdir -p bld && \
		    cd bld && \
		    ../unix/cmake/configure && \
		    make WIDTH=${WIDTH}) && \
		INTERPRETER_VM_DIR="${SRC}/target/${INTERPRETER_VERSION}-src-${WIDTH}/bld" &&
		INTERPRETER_VM="${INTERPRETER_VM_DIR}/squeak"
		echo Using the shiny new VM at ${INTERPRETER_VM_DIR};;
	    *) echo "Unknown OS ${1} for interpreter VM. Aborting." \
		exit 1;;
	esac
	if test -f $INTERPRETER_VM; then
            # Fall back to an assumed installed VM.
            # The path used in ./build-local.sh.
            INTERPRETER_VM_DIR="/usr/local/bin"
	    INTERPRETER_VM="${INTERPRETER_VM_DIR}/squeak"
	    echo Falling back to the VM at ${INTERPRETER_VM_DIR}
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

run_tests() {
    # Params:
    # $1: Source image name
    # $2: Package/script name
    SOURCE=$1
    PACKAGE=$2
    ARGS=$(vm_args "linux")
    (mkdir -p "${SRC}/target";
	cp prepare-test-image.st "${SRC}/target/prepare-test-image.st"; \
	cd "${SRC}/target"; \
	cp ${SOURCE}.image ${PACKAGE}.image && \
	cp ${SOURCE}.changes ${PACKAGE}.changes)
    (nice $VM ${ARGS} "${SRC}/target/${PACKAGE}.image" "prepare-test-image.st" && \
	nice $VM ${ARGS} "${SRC}/target/${PACKAGE}.image" "${SRC}/package-load-tests/${PACKAGE}.st")
    (cd "${SRC}/target"; \
	rm ${PACKAGE}.image && \
	rm ${PACKAGE}.changes)
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
