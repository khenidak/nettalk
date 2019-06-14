
#!/bin/bash

set -u
set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="${DIR}/../../"
COMMON_SCRIPT="${REPO_ROOT}/env/common.sh"
source "${COMMON_SCRIPT}"


echo "** demo-4 cleaning up"

exec_on_vm "vm0" "sudo pkill demo-4-server"
exec_on_vm "vm0" "rm -rf ~/demo-4"
