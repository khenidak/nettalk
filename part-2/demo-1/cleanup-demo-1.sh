#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"


#start here
print_header "part-2/cleanup-demo-1"

echo "** let us clear all nat table entries"
exec_on_vm "vm0" "sudo iptables -t nat -F"

