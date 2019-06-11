#!/bin/bash
set -e
set -o pipefail
set u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONTENT_ROOT="$(dirname "${DIR}")"
source "${DIR}/common.sh"

# creates a bridge and configure
teardown_network(){
  virsh net-destroy demo-net > /dev/null 2>&1 || true
}


stop_remove_vms(){
for idx in {0..2}; do
  virsh shutdown "demo-vm${idx}" > /dev/null 2>&1 || true
  virsh destroy "demo-vm${idx}" > /dev/null 2>&1 || true
  virsh undefine "demo-vm${id}" > /dev/null 2>&1 || true
done
}
## start here

echo "i am running at: $(pwd)"
echo "my directory is at: ${DIR}"
echo "content is at: ${CONTENT_ROOT}"


echo "** stopping and removing vms.."
stop_remove_vms
echo "** vms have been stopped and removed."

echo "** deleting network.."
teardown_network
echo "** network deleted"

echo "** note: we are not deleting the output dir"
echo "** if you want to delete it run: [rm -r ${CONTENT_ROOT}/${OUTPUT_DIR}]"
echo "** you can still run [${DIR}/setup.sh] and everything will be back on track"
