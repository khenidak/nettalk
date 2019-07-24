#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"

#start here
print_header "part-2/demo-1"

echo "** let us clear all nat table entries"
exec_on_vm "vm0" "sudo iptables -t nat -F"

echo "** iptables (nat table).."
exec_on_vm "vm0" "sudo iptables -t nat -L OUTPUT --line-numbers"

echo "** use cloudflare DNS to resolve microsoft.com"
exec_on_vm "vm0" "nslookup microsoft.com 1.1.1.1"

echo "** DNAT udp going to cloudflare:1.1.1.1 => google:8.8.8.8"
exec_on_vm "vm0" "sudo iptables -t nat -A OUTPUT  --protocol udp --destination 1.1.1.1  -j DNAT --to-destination 8.8.8.8"

echo "** iptables (nat table).."
exec_on_vm "vm0" "sudo iptables -t nat -L OUTPUT --line-numbers"

echo "** use cloudflare DNS to resolve microsoft.com"
exec_on_vm "vm0" "nslookup microsoft.com 1.1.1.1"

# flush again 
echo "** let us clear all filter table entries"
exec_on_vm "vm0" "sudo iptables -t nat -F"



