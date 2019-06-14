#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"

#reset since sourcing changed it. TODO
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

build_sender(){
	cd "${DIR}/sender"
	mkdir -p  "${REPO_ROOT}/output/demo-1/"
	go build -o "${REPO_ROOT}/output/demo-1/demo-1-sender"
	cd -
}
#start here
print_header "part-1/demo-1/step-0"

build_sender

# copy to server
exec_on_vm "vm0" 'mkdir -p ~/demo-1'
copy_to_vm "vm0" "${REPO_ROOT}/output/demo-1/demo-1-sender" '~/demo-1/'

# run server
echo "** running server on vm0"
exec_on_vm "vm0" 'sudo ~/demo-1/demo-1-sender'
