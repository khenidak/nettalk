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



