#!/bin/bash

# GAME TURBO TOOL
# Developer: Eslam Ramadan
# GitHub: https://github.com/Eslam3537

# === COLORS ===
red="\e[31m"
green="\e[32m"
blue="\e[34m"
cyan="\e[36m"
reset="\e[0m"

# === ASCII LOGO ===
logo="
 ██████╗  █████╗ ███╗   ███╗███████╗
██╔════╝ ██╔══██╗████╗ ████║██╔════╝
██║  ███╗███████║██╔████╔██║█████╗  
██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  
╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
       🚀 Game Turbo Tool 🚀
        by Eslam Ramadan
"

# === NOTIFICATION ===
termux-notification --title "Game Turbo 🚀" \
 --content "Activated by Eslam Ramadan" \
 --priority high > /dev/null 2>&1

# === MENU ===
while true; do
    clear
    echo -e "$cyan$logo$reset"
    echo -e "$green Select an option:$reset"
    echo "1) Clean Cache"
    echo "2) Free RAM"
    echo "3) Close Background Apps"
    echo "4) Boost Network (Flush DNS)"
    echo "5) Show Device Stats"
    echo "6) Update Game Turbo"
    echo "0) Exit"
    echo
    read -p "Enter choice: " choice

    case $choice in
        1)
            echo -e "$blue Cleaning cache...$reset"
            rm -rf /data/data/com.termux/cache/*
            sleep 1
            ;;
        2)
            echo -e "$blue Freeing RAM...$reset"
            am kill-all
            sleep 1
            ;;
        3)
            echo -e "$blue Closing background apps...$reset"
            am kill-all
            sleep 1
            ;;
        4)
            echo -e "$blue Flushing DNS...$reset"
            ndc resolver flushdefaultif
            sleep 1
            ;;
        5)
            echo -e "$blue Device Status:$reset"
            termux-battery-status
            termux-storage-get
            free -h
            sleep 3
            ;;
        6)
            echo -e "$green Updating Game Turbo...$reset"
            cd $HOME
            rm -f game-turbo.sh
            curl -o game-turbo.sh https://raw.githubusercontent.com/Eslam3537/game-turbo/main/game-turbo.sh
            chmod +x game-turbo.sh
            echo -e "$cyan Update complete! Restarting...$reset"
            sleep 2
            bash game-turbo.sh
            exit 0
            ;;
        0)
            echo -e "$red Exiting...$reset"
            exit 0
            ;;
        *)
            echo -e "$red Invalid option!$reset"
            ;;
    esac
    sleep 2
done
