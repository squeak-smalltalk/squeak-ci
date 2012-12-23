SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"

build_cog_vm () {
    if test -f $COG_VM; then
	echo Using pre-existing Cog VM at ${COG_VM}
    else
	echo Downloading Cog VM r${COG_VERSION}
	mkdir -p "${SRC}/target/cog.r${COG_VERSION}"
	(cd cog.r${COG_VERSION} && \
	    curl -o coglinux.tgz http://www.mirandabanda.org/files/Cog/VM/VM.r${COG_VERSION}/coglinux.tgz && \
	    tar zxvf coglinux.tgz)
    fi
}

build_interpreter_vm () {
    if test -f $INTERPRETER_VM; then
	echo Using pre-existing interpreter VM at ${INTERPRETER_VM}
    else
	echo Downloading Interpreter VM ${INTERPRETER_VERSION}
	mkdir -p "${SRC}/target/"
	(cd "${SRC}/target/" && \
	    curl -o interpreter.tgz http://www.squeakvm.org/unix/release/${INTERPRETER_VERSION}-src.tar.gz && \
	    tar zxvf interpreter.tgz && \
	    cd "${SRC}/target/${INTERPRETER_VERSION}-src" && \
	    mkdir -p bld && \
	    cd bld && \
	    ../unix/cmake/configure && \
	    make)
	if test -f $INTERPRETER_VM; then
            # Fall back to an assumed installed VM.
            # The path used in ./build-local.sh.
	    INTERPRETER_VM="/usr/local/bin/squeak"
	fi
    fi
}