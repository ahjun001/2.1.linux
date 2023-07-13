#!/usr/bin/env bash

# https://www.thegeekdiary.com/how-to-configure-and-manage-network-connections-using-nmcli/
# https://www.golinuxcloud.com/nmcli-command-examples-cheatsheet-centos-rhel/
# https://www.edureka.co/community/66884/activation-of-network-connection-failed-in-linux
# man nmcli

command_args_ok=true

case $1 in
NOC)
    my_adapter_1=Neustar\ DNS\ Advantage
    my_adapter_2=Automatic\ DNS
    my_device=enp1s0
    ;;
MSSB)
    my_adapter_1=Auto\ Linksys06800
    my_adapter_2="$my_adapter_1"
    my_device=wlp3s0
    ;;
*)
    command_args_ok=false
    echo "first command-line argument $1 not recognized, should be NOC or MSSB"
    ;;
esac

if [ "$command_args_ok" = true ]; then
    case $2 in
    i)
        set -x
        inxi -n
        echo
        systemctl --type=service | grep -i network
        echo
        nmcli general status
        echo
        nmcli dev status
        echo
        nmcli con show
        echo
        echo 'check networking status'
        nmcli networking
        echo
        set +x
        ;;
    1)
        set -x
        nmcli networking on
        set +x
        ;;
    2)
        set -x
        sudo systemctl restart networking
        echo $?
        set +x
        ;;
    3)
        set -x
        sudo systemctl restart NetworkManager
        echo $?
        set +x
        ;;
    4)
        set -x
        sudo nmcli connection reload
        echo $?
        set +x
        ;;
    5)
        set -x
        nmcli connection up "$my_adapter_1"
        echo $?
        set +x
        ;;
    6)
        set -x
        nmcli connection up "$my_adapter_2"
        echo $?
        set +x
        ;;
    7)
        set -x
        sudo dhclient "$my_device"
        echo $?
        set +x
        ;;
    8)
        set -x
        nmcli device connect "$my_device"
        echo $?
        set +x
        ;;
    9)
        set -x
        sudo /etc/init.d/networking restart
        echo $?
        set +x
        ;;
    10)
        set -x
        sudo apt install network-manager --reinstall
        echo $?
        set +x
        ;;
    *)
        command_args_ok=false
        echo "second command-line argument $2 not recognized, should be i or [1-10]"
        echo 'activateNetwork.sh [NOC, MSSB] i      for info on the connection'
        echo 'activateNetwork.sh [NOC, MSSB] [1-10] to restore lost connection'
        ;;
    esac

fi