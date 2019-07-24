#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"


#start here
print_header "part-2/demo-0"

echo "** let us clear all filter table entries"
exec_on_vm "vm0" "sudo iptables -t filter -F"

echo "** iptables (filter table).."
exec_on_vm "vm0" "sudo iptables -t filter -L OUTPUT --line-numbers"

echo "** use cloudflare DNS to resolve microsoft.com"
exec_on_vm "vm0" "nslookup microsoft.com 1.1.1.1"

echo "** block udp traffic to cloudflare dns server"
exec_on_vm "vm0" "sudo iptables -t filter -A OUTPUT  --protocol udp --destination 1.1.1.1 -j DROP"

echo "** iptables (filter table).."
exec_on_vm "vm0" "sudo iptables -t filter -L OUTPUT --line-numbers"

echo "** use cloudflare DNS to resolve microsoft.com"
exec_on_vm "vm0" "nslookup microsoft.com 1.1.1.1"

# flush again 
echo "** let us clear all filter table entries"
exec_on_vm "vm0" "sudo iptables -t filter -F"



