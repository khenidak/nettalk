!/bin/bash
set -e
set -o pipefail
set u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${DIR}/common.sh"

# creates a bridge and configure
setup_network(){
  # we offload the network stuff to virsh
  # 192 net..
  virsh net-create ${DIR}/network.xml
}


ensure_images(){
  if [[ ! -f "${image_name}" ]]; then
    echo "** image was not found, downloading.."
    wget -O "${image_name}" https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
  else
    echo "** image is available.."
  fi
}

build_images(){
  for idx in {0..2}; do
    # cloud init
    rm -f "${OUTPUT_DIR}/demo-vm${idx}.seed"
    cloud-localds "${OUTPUT_DIR}/demo-vm${idx}.cloudinit.disk" "${DIR}/demo-vm${idx}.seed"
    # os disk
    rm -f "${OUTPUT_DIR}/demo-vm${idx}.os.disk"
    cp -v "${image_name}" "${OUTPUT_DIR}/demo-vm${idx}.os.disk"
  done
}


start_vms(){
for idx in {0..2}; do
  virsh shutdown "demo-vm${idx}"  > /dev/null 2>&1 || true
  virsh destroy  "demo-vm${idx}"  > /dev/null 2>&1 || true
  virsh undefine "demo-vm${idx}"  > /dev/null 2>&1 || true

  echo "** starting demo-vm${idx}.."
  virt-install \
    --virt-type kvm \
    --name "demo-vm${idx}" \
    --ram 2048 \
    --vcpus 2 \
    --network network=demo-net,mac=${vm_macs[$idx]} \
    --disk path="${OUTPUT_DIR}/demo-vm${idx}.os.disk",device=disk,bus=virtio \
    --disk path="${OUTPUT_DIR}/demo-vm${idx}.cloudinit.disk",device=cdrom \
    --import  \
    --noautoconsole \
    --graphics none > /dev/null 2>&1
  echo "** demo-vm${idx} started"
done
}


## start here
echo "i am running at: $(pwd)"
echo "my directory is at: ${DIR}"
echo "content is at: ${CONTENT_ROOT}"

mkdir -p "${OUTPUT_DIR}"

echo "** creating network.."
setup_network
echo "** network created"

echo "** ensuring that we have images to work with.."
ensure_images
echo "** images ensured"

echo "** creating disks disks.."
build_images
echo "** disks were created"

echo "** starting vms.."
start_vms
echo "** vms started"

echo "** waiting 20s"
sleep 30

echo "** VMs running, ARP table"
arp
