#!/bin/bash

# 🎮 Game Turbo Script by Eslam Ramadan
# 🚀 Optimize Android performance via Termux

# Colors
green="\e[32m"
red="\e[31m"
yellow="\e[33m"
blue="\e[34m"
nc="\e[0m"

# Banner (ASCII Art)
banner() {
cat << "EOF"
   _____                      _______              _             
  / ____|                    |__   __|            | |            
 | |  __  __ _ _ __ ___   ___   | | ___  _ __   __| | ___  _ __  
 | | |_ |/ _` | '_ ` _ \ / _ \  | |/ _ \| '_ \ / _` |/ _ \| '_ \ 
 | |__| | (_| | | | | | |  __/  | | (_) | | | | (_| | (_) | | | |
  \_____|\__,_|_| |_| |_|\___|  |_|\___/|_| |_|\__,_|\___/|_| |_| 
                                                                  
       ⚡ Optimizer Tool | By: Eslam Ramadan ⚡
EOF
}

# Loading Animation
loading() {
    spin='-\|/'
    i=0
    while [ $i -lt 10 ]; do
        i=$(( (i+1) %4 ))
        printf "\r${yellow}[*] Loading... ${spin:$i:1}${nc}"
        sleep 0.2
    done
    echo -ne "\r${green}[✓] Done!${nc}\n"
}

# Auto Update
auto_update() {
    echo -e "${yellow}[+] Checking for updates...${nc}"
    cd $HOME
    if [ -d "game-turbo" ]; then
        cd game-turbo
        git pull origin main
        echo -e "${green}[✓] Updated to latest version.${nc}"
    else
        git clone https://github.com/Eslam3537/game-turbo.git
        cd game-turbo
        echo -e "${green}[✓] Installed latest version.${nc}"
    fi
    chmod +x game-turbo.sh
}

# Functions
clear_cache() {
    echo -e "${blue}[+] Clearing cache...${nc}"
    pm clear $(pm list packages -3 | cut -f 2 -d ":") >/dev/null 2>&1
    loading
    echo -e "${green}[✓] Cache cleared!${nc}"
}

kill_bg_apps() {
    echo -e "${blue}[+] Killing background apps...${nc}"
    am kill-all >/dev/null 2>&1
    loading
    echo -e "${green}[✓] Background apps closed!${nc}"
}

optimize_ram() {
    echo -e "${blue}[+] Optimizing RAM...${nc}"
    termux-setup-storage >/dev/null 2>&1
    sync; echo 3 > /proc/sys/vm/drop_caches
    loading
    echo -e "${green}[✓] RAM optimized!${nc}"
}

network_boost() {
    echo -e "${blue}[+] Boosting network...${nc}"
    ping -c 3 google.com >/dev/null 2>&1
    loading
    echo -e "${green}[✓] Network optimized!${nc}"
}

device_info() {
    echo -e "${yellow}----- Device Info -----${nc}"
    echo -e "Battery: $(termux-battery-status | grep percentage)"
    echo -e "Storage: $(df -h /storage/emulated | tail -1 | awk '{print $4}') free"
    echo -e "RAM: $(free -h | grep Mem | awk '{print $4}') free"
    echo -e "${yellow}-----------------------${nc}"
}

# Main Menu
while true; do
    clear
    banner
    echo -e "${blue}Select an option:${nc}"
    echo "1) Clear Cache"
    echo "2) Kill Background Apps"
    echo "3) Optimize RAM"
    echo "4) Boost Network"
    echo "5) Show Device Info"
    echo "6) Exit"
    echo "7) Manual Update"
    echo ""
    read -p "Enter choice: " choice

    case $choice in
        1) clear_cache ;;
        2) kill_bg_apps ;;
        3) optimize_ram ;;
        4) network_boost ;;
        5) device_info ;;
        6) exit 0 ;;
        7) auto_update ;;
        *) echo -e "${red}[!] Invalid choice${nc}" ;;
    esac
    read -p "Press Enter to continue..."
done
