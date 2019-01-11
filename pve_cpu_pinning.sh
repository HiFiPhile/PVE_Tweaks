#!/bin/bash

#Credit to ayufan
#https://gist.github.com/ayufan/37be5c0b8fd26113a8be

set -eo pipefail

if [[ "$#" -ne 2 ]]; then
    echo "Usage: `basename "$0"` VMID CPU_List"
    echo "Example: `basename "$0"` 100 0,1,2,3"
    exit 1
fi

VMID=$1

HCPUS=()
for i in ${2//,/ }
do
    HCPUS+=("$i")
done
HCPU_COUNT="${#HCPUS[@]}"

cpu_tasks() {
	expect <<EOF | sed -n 's/^.* CPU .*thread_id=\(.*\)$/\1/p' | tr -d '\r' || true
spawn qm monitor $VMID
expect ">"
send "info cpus\r"
expect ">"
EOF
}

VCPUS=($(cpu_tasks))
VCPU_COUNT="${#VCPUS[@]}"

if [[ $VCPU_COUNT -eq 0 ]]; then
	echo "* No VCPUS for VM$VMID"
	exit 1
fi

echo "* Detected ${#VCPUS[@]} assigned to VM$VMID..."

if [[ $VCPU_COUNT -ne $HCPU_COUNT ]]; then
	echo "* Virtual CPU count and affinity list count not equal..."
	exit 1
fi

for VCPU_INDEX in "${!VCPUS[@]}"
do
	HCPU="${HCPUS[$VCPU_INDEX]}"
	CPU_TASK="${VCPUS[$VCPU_INDEX]}"
	echo "* Assigning $HCPU to $CPU_TASK..."
	taskset -pc "$HCPU" "$CPU_TASK"
done