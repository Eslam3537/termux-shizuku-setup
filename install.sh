#!/bin/bash

# =========================================
#  Islam Ramadan | Termux Setup Tool
# =========================================

clear
echo "=========================================="
echo " 🔰 Islam Ramadan | Termux Setup Tool 🔰"
echo "=========================================="
echo
echo "[1] Install Termux Essentials"
echo "[2] Setup Shizuku (rish)"
echo "[0] Exit"
echo
echo "=========================================="

read -p "Choose an option: " option

case $option in
    1)
        echo ">>> Installing Termux Essentials..."
        pkg update -y && pkg upgrade -y
        pkg install -y git wget curl nano python python-pip
        echo ">>> Termux Essentials Installed Successfully!"
        ;;
    2)
        echo ">>> Setting up Shizuku (rish)..."
        pkg install -y wget
        wget https://raw.githubusercontent.com/RikkaApps/Shizuku/master/scripts/rish.sh -O rish.sh
        chmod +x rish.sh
        ./rish.sh
        echo ">>> Shizuku (rish) setup completed!"
        ;;
    0)
        echo "Exiting... Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid option, please try again."
        ;;
esac
