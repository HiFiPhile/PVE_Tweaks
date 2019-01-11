# PVE_Tweaks
Multiple tweaks for Proxmox

## CPU Pinning
pve_cpu_pinning.sh
```bash
pve_cpu_pinning.sh VMID CPU_Cores
pve_cpu_pinning.sh 100 0,1,2,3
```
## Change scheduler to fifo
pve_schd_fifo.sh
```bash
pve_schd_fifo.sh VMID
pve_schd_fifo.sh 100
```
## Patch QemuServer to not free hugepages
QemuServer_NoHugeFree.patch
```bash
patch /usr/share/perl5/PVE/QemuServer.pm ./QemuServer_NoHugeFree.patch
```
## Patch QemuServer to run post start command
QemuServer_PostCommand.patch
```bash
patch /usr/share/perl5/PVE/QemuServer.pm ./QemuServer_PostCommand.patch
```
Add "postcommand: PATH_TO_COMMAND" in vm config file:
```bash
postcommand: /home/vm100_startup.sh
```

# Disclaimer
These tweaks are provided as-are, and there are no guarantees that they fit your purposes or that they are bug-free. Use it at your own risk!
