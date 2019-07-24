#!/bin/bash
set -e
set -o pipefail
set u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONTENT_ROOT="$(dirname "${DIR}")"
OUTPUT_DIR="${CONTENT_ROOT}/output"

image_name="${OUTPUT_DIR}/bionic-server-cloudimg-amd64.img"

vm_ips=("192.168.99.10" "192.168.99.20" "192.168.99.30")
vm_macs=("52:54:00:4c:40:1c"  "52:54:00:4c:40:12" "52:54:00:4c:40:13")

# common functions
print_header(){
	local demo_name="${1}"
	#those vars are responsibility of sourc-er to include
	echo "**********************************"
	echo "** RUNNING: ${demo_name}"
	echo "**********************************"
	echo "** REPO: ${REPO_ROOT}"
	echo "** PWD: $(pwd)"
	echo "**"
	echo "**"
}
vm_to_idx(){
	local vm="$1"
	local len="${#vm}"
	len=$((len-1))
	echo -n "${vm:${len}}"
}

exec_on_vm(){
	local vm="$1"
	local cmd="$2"
	local idx=""

	idx="$(vm_to_idx "${vm}")"

	echo "** executing:"
	echo "** [VM]:${vm}"
	echo "** [++]:${cmd}"

	ssh  -o LogLevel=ERROR -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" ${vm_ips[$idx]} "${cmd}" 
}

copy_to_vm(){
	local vm="$1"
	local src="$2"
	local dst="$3"

	local idx=""

	idx="$(vm_to_idx "${vm}")"

	echo "** copying $src $vm:$dst"
	scp -o LogLevel=ERROR -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" ${src} ${vm_ips[$idx]}:${dst}
}

copy_from_vm(){
	local vm="$1"
	local src="$2"
	local dst="$3"

	local idx=""

	idx="$(vm_to_idx "${vm}")"

	echo "** copying $src $vm:$dst"
	scp -o "StrictHostKeyChecking=no" ${vm_ips[$idx]}:${src} ${dst}
}
