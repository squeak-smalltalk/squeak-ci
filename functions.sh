SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"

build_cog_vm () {
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
	    *) echo "Unknown OS ${1} for Cog VM. Aborting." \
		exit 1;;
	esac
    fi
}

build_interpreter_vm () {
    # Param:
    # $1: The name of the operating system. Currently only accepts "linux"
    if test -f $INTERPRETER_VM; then
	echo Using pre-existing interpreter VM at ${INTERPRETER_VM}
    else
	echo Downloading Interpreter VM ${INTERPRETER_VERSION}
	mkdir -p "${SRC}/target/"
	case $1 in
	    "linux")
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