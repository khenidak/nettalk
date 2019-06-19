#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"

print_header "part-1/demo-1/step-0"

echo "** tracing.."
echo "** JUMP TO VM1 and execute [sudo tcpdump -X  udp port 10010"]
#exec_on_vm "vm1" "sudo tcpdump -X  udp port 10010" 
# TODO figure out piping tcpdump over ssh
