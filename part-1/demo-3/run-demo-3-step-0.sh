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


build_udp_server(){
	cd "${DIR}/server"
	mkdir -p  "${REPO_ROOT}/output/demo-3/"
	go build -o "${REPO_ROOT}/output/demo-3/demo-3-server"
	cd -
}
#start here
print_header "part-1/demo-3/step-0"

build_udp_server

# copy to server
exec_on_vm "vm0" 'mkdir -p ~/demo-3'
copy_to_vm "vm0" "${REPO_ROOT}/output/demo-3/demo-3-server" '~/demo-3/'

# run server
echo "** running server on vm0"
exec_on_vm "vm0" '~/demo-3/demo-3-server'
