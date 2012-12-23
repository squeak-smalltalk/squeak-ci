SRC=$(cd $(dirname "$0"); pwd)

INTERPRETER_VERSION=Squeak-4.10.2.2614
COG_VERSION=2640
INTERPRETER_VM=target/${INTERPRETER_VERSION}-src/bld/squeak
COG_VM="${SRC}/cog.r${COG_VERSION}/coglinux/bin/squeak"

export INTERPRETER_VERSION
export INTERPRETER_VM
export COG_VERSION
export COG_VM