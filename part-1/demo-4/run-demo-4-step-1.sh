#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"

print_header "part-1/demo-4/step-1"

echo "** curl our basic server on vm1 to vm0(${vm_ips[0]}):10020"
exec_on_vm "vm1" "curl -s -vvv ${vm_ips[0]}:10020"
echo ""
