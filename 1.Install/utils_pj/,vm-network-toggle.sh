#!/usr/bin/env bash
# ,vm-network-toggle - Switch between network modes
set -euo pipefail

Usage() {
    cat <<EOF2
    Usage: setup-vm-networking_4.sh {office|mobile|status|help}
EOF2
}

Help() {
    cat <<EOF3

=== WORKFLOW INSTRUCTIONS ===

1. AT OFFICE (dual NIC available):
   - Connect both cables (WAN and LAN)
   - Switch to office mode:
     ,vm-network-toggle office
   - Host uses WAN, VM uses LAN exclusively

2. ON THE GO (single NIC available):
   - Connect available network (WAN or WiFi)
   - Switch to mobile mode:
     ,vm-network-toggle mobile
   - Host and VM share the connection via NAT

3. CHECK CURRENT MODE:
   ,vm-network-toggle status

4. VM CONFIGURATION:
   - Always configure VM with single NIC using:
     <interface type='network'>
       <source network='vm-network'/>
     </interface>

5. RESET TO CLEAN STATE:
   Simply rerun this setup script

=== TROUBLESHOOTING ===
- If connections don't work, check:
  sudo nmcli connection show --active
  sudo virsh net-info vm-network
  ip route show
EOF3
}

if [[ ! "$#" -eq 1 ]]; then
    Usage
    exit 1
fi

# Check if USB NIC is physically present
USB_NIC_PRESENT=$(lsusb | grep -i "LAN NIC" || ip link show enp4s0f4u1 2>/dev/null)

case "$1" in
office)
    if [ -z "$USB_NIC_PRESENT" ]; then
        echo "USB NIC not detected - cannot enable office mode"
        exit 1
    fi

    echo "Setting office mode (host WAN + VM LAN)"
    # Ensure WAN is up
    echo 'connecting wan-connection' && sudo nmcli connection up "wan-connection" && sleep 1
    # Activate bridge
    echo 'connecting vm-bridge-conn' && sudo nmcli connection up "vm-bridge-conn" && sleep 1
    echo 'connecting vm-bridge-slave' && sudo nmcli connection up "vm-bridge-slave" && sleep 1
    # Switch libvirt network
    # Stop and undefine existing network if it exists
    sudo virsh net-destroy "vm-network" 2>/dev/null || true
    sudo virsh net-undefine "vm-network" 2>/dev/null || true
    # Define and start the bridge network
    sudo cp -v "/etc/libvirt/qemu/networks/vm-network-bridge.xml" "/etc/libvirt/qemu/networks/vm-network.xml"
    sudo virsh net-define "/etc/libvirt/qemu/networks/vm-network.xml"
    sudo virsh net-start "vm-network"
    sudo virsh net-autostart "vm-network"
    ;;
mobile)
    echo "Setting mobile mode (shared NAT)"
    # Deactivate bridge if USB NIC is present
    if [ -n "$USB_NIC_PRESENT" ]; then
        sudo nmcli connection down "vm-bridge-conn" 2>/dev/null || true
        sudo nmcli connection down "vm-bridge-slave" 2>/dev/null || true
    fi

    # Switch libvirt network
    # Stop and undefine existing network if it exists
    sudo virsh net-destroy "vm-network" 2>/dev/null || true
    sudo virsh net-undefine "vm-network" 2>/dev/null || true
    # Define and start the NAT network
    sudo cp "/etc/libvirt/qemu/networks/vm-network-nat.xml" "/etc/libvirt/qemu/networks/vm-network.xml"
    sudo virsh net-define "/etc/libvirt/qemu/networks/vm-network.xml"
    sudo virsh net-start "vm-network"
    sudo virsh net-autostart "vm-network"
    ;;
status)
    echo "Current connections:"
    sudo nmcli -t -f NAME,DEVICE,STATE connection show --active
    echo -e "\nLibvirt network:"
    sudo virsh net-info "vm-network" 2>/dev/null || echo "Not active"
    ;;
help)
    Help
    ;;
*)
    Usage
    exit 1
    ;;
esac

# Show final status
if [[ "$1" != "status" ]]; then
    echo "Mode change completed. Current status:"
    sudo nmcli -t -f NAME,DEVICE,STATE connection show --active
    sudo virsh net-info "vm-network"
fi

# make a soft link in /usr/local/bin
LINK=/usr/local/bin/"${0##*/}"
FILE=$(realpath "$0")
[[ -L $LINK ]] || sudo ln -fs "$FILE" "$LINK"
