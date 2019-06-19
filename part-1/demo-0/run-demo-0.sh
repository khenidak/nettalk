#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"


run_demo(){
	# flush arp, wait, trace for arp packet while we are pinging
	local cmd="sudo ip -s -s neigh flush all 2>&1 > /dev/null && sudo tcpdump -lni any arp &  sleep 1; ping -c1 -n ${vm_ips[1]} 2>&1 > /dev/null"
	echo "** CTRL+C to stop.."
	echo "** pinging vm1(${vm_ips[1]}) from vm0 (${vm_ips[0]})"
	exec_on_vm "vm0" "$cmd"
}

#start here
print_header "part-1/demo-0"

run_demo
