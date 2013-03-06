SRC=$(cd $(dirname "$0"); pwd)

SQUEAK_VERSION=Squeak4.5

INTERPRETER_VERSION=Squeak-4.10.2.2614
COG_VERSION=2697
INTERPRETER_VM_DIR="${SRC}/target/${INTERPRETER_VERSION}-src-32/bld"
INTERPRETER_VM="${INTERPRETER_VM_DIR}/squeak"
COG_VM="${SRC}/target/cog.r${COG_VERSION}/coglinux/bin/squeak"
BASE_URL="http://build.squeak.org/"

export INTERPRETER_VERSION
export INTERPRETER_VM
export COG_VERSION
export COG_VM
