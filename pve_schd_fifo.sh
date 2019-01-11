#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: `basename "$0"` VMID"
    echo "Example: `basename "$0"` 100"
    exit 1
fi

KPID=($(qm list | awk -v pid="$1" '$1 == pid {print $NF}'))

if [[ $KPID -eq 0 ]]; then
	echo "* Can not find PID for VM:$1"
	exit 1;
fi

echo "* Set VM:"$1"'s (PID=$KPID) scheduler to FIFO..."
chrt -f -p 1 $KPID
chrt -p $KPID