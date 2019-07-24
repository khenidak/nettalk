#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"

source "${COMMON_SCRIPT}"

## this needs to be running on VM1 socat - udp4-listen:5000,fork | xxd


#start here
print_header "part-2/demo-2-step-1"

echo "** let us clear all nat table entries"
exec_on_vm "vm0" "sudo iptables -t nat -F"

echo "** iptables (nat table).."
exec_on_vm "vm0" "sudo iptables -t nat -L POSTROUTING --line-numbers"

echo "** use cloudflare DNS to resolve microsoft.com"
exec_on_vm "vm0" "nslookup microsoft.com 1.1.1.1"

echo "** SNAT traffic going to 1.1.1. with VM1  IP 192.168.99.20:5000"
exec_on_vm "vm0" "sudo iptables -t nat -A POSTROUTING  --protocol udp --destination 1.1.1.1  -j SNAT --to-source 192.168.99.20:5000"

echo "** iptables (nat table).."
exec_on_vm "vm0" "sudo iptables -t nat -L POSTROUTING --line-numbers"

echo "** use cloudflare DNS to resolve microsoft.com"
exec_on_vm "vm0" "nslookup microsoft.com 1.1.1.1"

# flush again 
echo "** let us clear all filter table entries"
exec_on_vm "vm0" "sudo iptables -t nat -F"



