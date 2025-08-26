#!/data/data/com.termux/files/usr/bin/bash
# =========================================
#   Eslam Ramadan | Android Game Booster
#   Termux menu tool (Shizuku-aware) + Auto Update
# =========================================

# Script version and repository info
VERSION="1.0.1"
REPO_URL="https://github.com/EslamRamadan0/Android-Game-Booster.git"
SCRIPT_NAME="game_booster.sh"

# -------- Colors --------
c0='\033[0m'; c1='\033[1;36m'; c2='\033[1;32m'; c3='\033[1;33m'; c4='\033[1;31m'

# -------- Logging --------
STATE_DIR="$HOME/.eslam_gamebooster"
mkdir -p "$STATE_DIR"
LOG_FILE="$STATE_DIR/error.log"

log_error() {
  echo "[$(date)] $1" >> "$LOG_FILE"
}

# -------- Check Termux Environment --------
check_termux_env() {
  if [ -z "$PREFIX" ] || [ ! -d "$PREFIX" ]; then
    msg "$c4" ">>> Error: This script must be run in a Termux environment."
    exit 1
  fi
}

# -------- Check Android Version --------
check_android_version() {
  local version=$(getprop ro.build.version.release 2>/dev/null)
  if [ -z "$version" ] || [ "${version%%.*}" -lt 8 ]; then
    msg "$c4" ">>> Warning: This tool may not work properly on Android versions below 8."
  fi
}

# -------- Auto Update --------
auto_update() {
  msg "$c3" ">>> Checking for updates..."
  
  if ! command -v git >/dev/null 2>&1; then
    msg "$c4" ">>> Git is not installed. Run 'pkg install git' to enable auto-updates."
    return
  fi
  
  if ! ping -c 1 google.com >/dev/null 2>&1; then
    msg "$c4" ">>> No internet connection. Skipping auto-update."
    return
  fi
  
  if [ -d .git ]; then
    if git fetch origin main >/dev/null 2>&1; then
      LOCAL_HASH=$(git rev-parse HEAD)
      REMOTE_HASH=$(git rev-parse origin/main)
      
      if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        msg "$c3" ">>> Update found! Downloading..."
        if git pull --rebase origin main >/dev/null 2>&1; then
          chmod +x "$SCRIPT_NAME"
          msg "$c2" ">>> Tool updated to latest version. Please restart the script."
          exit 0
        else
          msg "$c4" ">>> Update failed. Continuing with current version."
          log_error "Failed to update script from $REPO_URL"
        fi
      else
        msg "$c2" ">>> You have the latest version."
      fi
    else
      msg "$c4" ">>> Could not access repository. Check your internet or repository URL."
      log_error "Could not access repository: $REPO_URL"
    fi
  else
    msg "$c4" ">>> Not a git repository, skipping auto-update."
  fi
  
  sleep 2
}

# -------- Detect Shizuku --------
has_rish=false
check_shizuku() {
  if command -v rish >/dev/null 2>&1; then
    if rish -c "settings get global window_animation_scale" >/dev/null 2>&1; then
      has_rish=true
    else
      msg "$c4" ">>> Shizuku is installed but not running or lacks permissions."
    fi
  else
    msg "$c4" ">>> Shizuku not found. Install 'pkg install shizuku' and start Shizuku."
  fi
}

# -------- Save/Restore Store --------
ANIM_BAK="$STATE_DIR/anim_scales.bak"
SYNC_BAK="$STATE_DIR/sync_state.bak"

# -------- Banner --------
banner() {
  clear
  echo -e "${c1}"
  echo "  ███████ ███████ ██      █████  ███    ███     ██████   █████  ██████   █████  ███    ██ "
  echo "  ██      ██      ██     ██   ██ ████  ████     ██   ██ ██   ██ ██   ██ ██   ██ ████   ██ "
  echo "  ███████ █████   ██     ███████ ██ ████ ██     ██████  ███████ ██   ██ ███████ ██ ██  ██ "
  echo "       ██ ██      ██     ██   ██ ██  ██  ██     ██   ██ ██   ██ ██   ██ ██   ██ ██  ██ ██ "
  echo "  ███████ ███████ ██████ ██   ██ ██      ██     ██   ██ ██   ██ ██████  ██   ██ ██   ████ "
  echo -e "${c0}"
  echo -e "             ${c3}Android Game Booster by Eslam Ramadan${c0}"
  echo -e "             ${c2}Version: $VERSION${c0}"
  if $has_rish; then
    echo -e "             ${c2}Shizuku detected: YES${c0}"
  else
    echo -e "             ${c4}Shizuku detected: NO${c0}"
  fi
  echo
}

msg() { echo -e "$1$2${c0}"; }
pause() { echo ""; read -p "Press Enter to return to menu..."; }

# -------- Basics (no root) --------
install_essentials() {
  msg "$c3" ">>> Installing Termux Essentials..."
  if pkg update -y && pkg upgrade -y && pkg install -y git curl wget nano python python-pip termux-api; then
    msg "$c2" ">>> Essentials installed successfully."
  else
    msg "$c4" ">>> Failed to install essentials. Check your internet or Termux sources."
    log_error "Failed to install Termux essentials"
  fi
}

light_clean_termux() {
  msg "$c3" ">>> Cleaning Termux caches/logs..."
  rm -rf "$HOME"/.cache/* 2>/dev/null
  find "$PREFIX/var/cache" -type f -delete 2>/dev/null
  find "$PREFIX/tmp" -mindepth 1 -delete 2>/dev/null
  msg "$c2" ">>> Termux cache cleaned."
}

focus_termux_only() {
  msg "$c3" ">>> Minimizing Termux overhead for focus session..."
  if command -v sv >/dev/null 2>&1; then
    for s in "$PREFIX"/var/service/*; do [ -d "$s" ] && sv down "$s" 2>/dev/null; done
  fi
  export PYTHONOPTIMIZE=2
  msg "$c2" ">>> Lightweight session variables applied."
}

# -------- Shizuku-powered helpers --------
SHELL_RUN() {
  if $has_rish; then
    rish "$@"
  else
    "$@"
  fi
}

backup_anim_scales() {
  if [ ! -f "$ANIM_BAK" ]; then
    local w a t
    w=$(SHELL_RUN settings get global window_animation_scale 2>/dev/null)
    a=$(SHELL_RUN settings get global animator_duration_scale 2>/dev/null)
    t=$(SHELL_RUN settings get global transition_animation_scale 2>/dev/null)
    if echo "${w:-1.0}|${a:-1.0}|${t:-1.0}" > "$ANIM_BAK" 2>/dev/null; then
      msg "$c2" ">>> Animation scales backed up."
    else
      msg "$c4" ">>> Failed to back up animation scales."
      log_error "Failed to back up animation scales"
    fi
  fi
}

set_anim_scales() {
  local val="$1"
  backup_anim_scales
  if SHELL_RUN settings put global window_animation_scale "$val" 2>/dev/null &&
     SHELL_RUN settings put global animator_duration_scale "$val" 2>/dev/null &&
     SHELL_RUN settings put global transition_animation_scale "$val" 2>/dev/null; then
    return 0
  else
    msg "$c4" ">>> Failed to set animation scales."
    log_error "Failed to set animation scales to $val"
    return 1
  fi
}

restore_anim_scales() {
  if [ -f "$ANIM_BAK" ]; then
    IFS='|' read -r w a t < "$ANIM_BAK"
    if SHELL_RUN settings put global window_animation_scale "${w:-1.0}" 2>/dev/null &&
       SHELL_RUN settings put global animator_duration_scale "${a:-1.0}" 2>/dev/null &&
       SHELL_RUN settings put global transition_animation_scale "${t:-1.0}" 2>/dev/null; then
      msg "$c2" ">>> Animation scales restored."
      return 0
    else
      msg "$c4" ">>> Failed to restore animation scales."
      log_error "Failed to restore animation scales"
      return 1
    fi
  else
    msg "$c4" ">>> No animation scales backup found."
    return 1
  fi
}

backup_sync() {
  if [ ! -f "$SYNC_BAK" ]; then
    s=$(SHELL_RUN settings get global master_sync 2>/dev/null)
    if echo "${s:-1}" > "$SYNC_BAK" 2>/dev/null; then
      msg "$c2" ">>> Master sync backed up."
    else
      msg "$c4" ">>> Failed to back up master sync."
      log_error "Failed to back up master sync"
    fi
  fi
}

set_master_sync() {
  local v="$1"
  backup_sync
  if SHELL_RUN settings put global master_sync "$v" 2>/dev/null; then
    return 0
  else
    msg "$c4" ">>> Failed to set master sync."
    log_error "Failed to set master sync to $v"
    return 1
  fi
}

restore_sync() {
  if [ -f "$SYNC_BAK" ]; then
    v=$(cat "$SYNC_BAK")
    if SHELL_RUN settings put global master_sync "${v:-1}" 2>/dev/null; then
      msg "$c2" ">>> Master sync restored."
      return 0
    else
      msg "$c4" ">>> Failed to restore master sync."
      log_error "Failed to restore master sync"
      return 1
    fi
  else
    msg "$c4" ">>> No master sync backup found."
    return 1
  fi
}

kill_background_apps() {
  msg "$c3" ">>> Killing background apps..."
  if SHELL_RUN am kill-all 2>/dev/null; then
    msg "$c2" ">>> Background apps killed."
    return 0
  else
    msg "$c4" ">>> Failed to kill background apps."
    log_error "Failed to kill background apps"
    return 1
  fi
}

force_stop_package() {
  msg "$c3" ">>> Force stopping a package..."
  read -rp "Enter package name: " P
  if [ -z "$P" ]; then
    msg "$c4" ">>> Error: No package name provided."
    return
  fi
  if ! SHELL_RUN pm list packages | grep -q "$P"; then
    msg "$c4" ">>> Error: Package '$P' not found."
    return
  fi
  if SHELL_RUN am force-stop "$P" 2>/dev/null; then
    msg "$c2" ">>> Package '$P' stopped successfully."
  else
    msg "$c4" ">>> Failed to stop package '$P'."
    log_error "Failed to stop package: $P"
  fi
}

compile_speed_package() {
  msg "$c3" ">>> Compiling package for speed..."
  read -rp "Enter package name: " P
  if [ -z "$P" ]; then
    msg "$c4" ">>> Error: No package name provided."
    return
  fi
  if ! SHELL_RUN pm list packages | grep -q "$P"; then
    msg "$c4" ">>> Error: Package '$P' not found."
    return
  fi
  if SHELL_RUN cmd package compile -m speed -f "$P" 2>/dev/null; then
    msg "$c2" ">>> Package '$P' compiled successfully."
  else
    msg "$c4" ">>> Failed to compile package '$P'."
    log_error "Failed to compile package: $P"
  fi
}

game_mode_on() {
  msg "$c3" ">>> Game Mode ON..."
  if $has_rish; then
    if set_anim_scales 0.0 && set_master_sync 0 && kill_background_apps; then
      msg "$c2" ">>> Game Mode Activated."
    else
      msg "$c4" ">>> Failed to activate Game Mode. Check Shizuku permissions."
      log_error "Failed to activate Game Mode"
    fi
  else
    msg "$c4" ">>> Shizuku not available. Please install and start Shizuku."
  fi
}

game_mode_off() {
  msg "$c3" ">>> Restoring system..."
  if $has_rish; then
    if restore_anim_scales && restore_sync; then
      msg "$c2" ">>> System restored successfully."
    else
      msg "$c4" ">>> Failed to restore system settings."
      log_error "Failed to restore system settings"
    fi
  else
    msg "$c4" ">>> Shizuku not available. Cannot restore settings."
  fi
}

install_tool() {
  msg "$c3" ">>> Installing/Updating Android Game Booster..."
  if ! command -v git >/dev/null 2>&1; then
    msg "$c4" ">>> Git is not installed. Installing now..."
    if pkg update -y && pkg install -y git; then
      msg "$c2" ">>> Git installed successfully."
    else
      msg "$c4" ">>> Failed to install git. Check your internet or Termux sources."
      log_error "Failed to install git"
      return
    fi
  fi
  if ! ping -c 1 google.com >/dev/null 2>&1; then
    msg "$c4" ">>> No internet connection. Cannot install/update."
    log_error "No internet connection for install/update"
    return
  fi
  if [ -d "$HOME/Android-Game-Booster" ]; then
    msg "$c3" ">>> Tool already installed. Updating..."
    cd "$HOME/Android-Game-Booster"
    if git pull origin main >/dev/null 2>&1; then
      chmod +x "$SCRIPT_NAME"
      msg "$c2" ">>> Update successful."
    else
      msg "$c4" ">>> Update failed. Check your internet connection."
      log_error "Failed to update tool from $REPO_URL"
      return
    fi
  else
    cd "$HOME"
    if git clone "$REPO_URL" >/dev/null 2>&1; then
      msg "$c2" ">>> Tool downloaded successfully."
      cd "Android-Game-Booster"
      chmod +x "$SCRIPT_NAME"
    else
      msg "$c4" ">>> Failed to download tool. Check your internet or repository URL."
      log_error "Failed to clone repository: $REPO_URL"
      return
    fi
  fi
  msg "$c2" ">>> Installation complete. Run the tool with:"
  msg "$c2" ">>> cd ~/Android-Game-Booster && ./$SCRIPT_NAME"
}

show_help() {
  echo -e "${c1}Android Game Booster - Help${c0}"
  echo
  echo "This tool optimizes your Android device for gaming via Termux."
  echo
  echo "To install/update the tool, run:"
  echo "  pkg install git"
  echo "  git clone $REPO_URL"
  echo "  cd Android-Game-Booster"
  echo "  chmod +x $SCRIPT_NAME"
  echo "  ./$SCRIPT_NAME"
  echo
  echo "Requirements:"
  echo "1. Shizuku installed and running (download from Play Store)."
  echo "2. Rish installed in Termux: pkg install shizuku"
  echo
  echo "Without Shizuku, some features will not work."
  echo
  read -p "Press Enter to continue..."
}

# -------- Main Execution --------
check_termux_env
check_android_version
check_shizuku
auto_update

while true; do
  banner
  echo -e "${c2}[1]${c0} Install Termux Essentials"
  echo -e "${c2}[2]${c0} Light Clean Termux"
  echo -e "${c2}[3]${c0} Focus Termux"
  echo -e "${c2}[4]${c0} Game Mode ON"
  echo -e "${c2}[5]${c0} Game Mode OFF"
  echo -e "${c2}[6]${c0} Kill Background Apps"
  echo -e "${c2}[7]${c0} Force Stop Package"
  echo -e "${c2}[8]${c0} Compile Package for Speed"
  echo -e "${c2}[9]${c0} Install/Update This Tool"
  echo -e "${c2}[H]${c0} Help"
  echo -e "${c2}[0]${c0} Exit"
  echo
  read -rp "Choose option: " ch
  case "$ch" in
    1) install_essentials; pause ;;
    2) light_clean_termux; pause ;;
    3) focus_termux_only; pause ;;
    4) game_mode_on; pause ;;
    5) game_mode_off; pause ;;
    6) kill_background_apps; pause ;;
    7) force_stop_package; pause ;;
    8) compile_speed_package; pause ;;
    9) install_tool; pause ;;
    h|H) show_help; ;;
    0) exit 0 ;;
    *) msg "$c4" "Invalid choice."; pause ;;
  esac
done
