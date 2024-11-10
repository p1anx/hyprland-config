#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

if [ $1 -eq "-i" ]; then
  source install.sh
fi
#echo "$ORANGE Select monitor resolution for better config appearance and fonts:"
#echo "$YELLOW 1. Equal to or less than 1080p (≤ 1080p)"
#echo "$YELLOW 2. Equal to or higher than 1440p (≥ 1440p)"
#read -p "$CAT Enter the number of your choice: " res_choice

#config param
res_choice=1 #1 <=1080p 2 >=1440p
#read -p "${CAT} Do you want to disable Rainbow Borders animation? (Y/N): " border_choice
border_choice=n #y disalbe rainbow border; n enable

clear
wallpaper=$HOME/.config/hypr/wallpaper_effects/.wallpaper_modified
waybar_style="$HOME/.config/waybar/style/[Dark] Latte-Wallust combined.css"
waybar_config="$HOME/.config/waybar/configs/[TOP] Default_v4"
waybar_config_laptop="$HOME/.config/waybar/configs/[TOP] Default Laptop_v4"

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
  echo "This script should not be executed as root! Exiting......."
  exit 1
fi

printf "\n%.0s" {1..2}
echo '  ╦╔═┌─┐┌─┐╦    ╦ ╦┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐  ╔╦╗┌─┐┌┬┐┌─┐ '
echo '  ╠╩╗│ ││ │║    ╠═╣└┬┘├─┘├┬┘│  ├─┤│││ ││───║║│ │ │ └─┐ '
echo '  ╩ ╩└─┘└─┘╩═╝  ╩ ╩ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘  ═╩╝└─┘ ┴ └─┘ '
printf "\n%.0s" {1..2}

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Create Directory for Copy Logs
if [ ! -d Copy-Logs ]; then
  mkdir Copy-Logs
fi

# Function to print colorful text
print_color() {
  printf "%b%s%b\n" "$1" "$2" "$CLEAR"
}

# Set the name of the log file to include the current date and time
LOG="Copy-Logs/install-$(date +%d-%H%M%S)_dotfiles.log"

# update home folders
xdg-user-dirs-update 2>&1 | tee -a "$LOG" || true

# setting up for nvidia
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
  echo "Nvidia GPU detected. Setting up proper env's and configs" 2>&1 | tee -a "$LOG" || true
  sed -i '/env = LIBVA_DRIVER_NAME,nvidia/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/env = NVD_BACKEND,direct/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  # enabling no hardware cursors if nvidia detected
  sed -i 's/^\([[:space:]]*no_hardware_cursors[[:space:]]*=[[:space:]]*\)false/\1true/' config/hypr/UserConfigs/UserSettings.conf
  # disabling explicit sync for nvidia for now (Hyprland 0.42.0)
  #sed -i 's/  explicit_sync = 2/  explicit_sync = 0/' config/hypr/UserConfigs/UserSettings.conf
fi

# uncommenting WLR_RENDERER_ALLOW_SOFTWARE,1 if running in a VM is detected
if hostnamectl | grep -q 'Chassis: vm'; then
  echo "System is running in a virtual machine." 2>&1 | tee -a "$LOG" || true
  # enabling proper ENV's for Virtual Environment which should help
  sed -i 's/^\([[:space:]]*no_hardware_cursors[[:space:]]*=[[:space:]]*\)false/\1true/' config/hypr/UserConfigs/UserSettings.conf
  sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/env = LIBGL_ALWAYS_SOFTWARE,1/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/monitor = Virtual-1, 1920x1080@60,auto,1/s/^#//' config/hypr/UserConfigs/Monitors.conf
fi

# Proper Polkit for NixOS
if hostnamectl | grep -q 'Operating System: NixOS'; then
  echo "You Distro is NixOS. Setting up properly." 2>&1 | tee -a "$LOG" || true
  sed -i -E '/^#?exec-once = \$scriptsDir\/Polkit-NixOS\.sh/s/^#//' config/hypr/UserConfigs/Startup_Apps.conf
  sed -i '/^exec-once = \$scriptsDir\/Polkit\.sh$/ s/^#*/#/' config/hypr/UserConfigs/Startup_Apps.conf
fi

# Check if dpkg is installed (use to check if Debian or Ubuntu or based distros
if command -v dpkg &>/dev/null; then
  echo "Debian/Ubuntu based distro. Disabling pyprland" 2>&1 | tee -a "$LOG" || true
  # disabling pyprland as causing issues
  sed -i '/^exec-once = pypr &/ s/^/#/' config/hypr/UserConfigs/Startup_Apps.conf
fi

printf "\n"

# Check if asusctl is installed and add rog-control-center on Startup
if command -v asusctl >/dev/null 2>&1; then
  sed -i '/exec-once = rog-control-center &/s/^#//' config/hypr/UserConfigs/Startup_Apps.conf
fi

printf "\n"

# Action to do for better rofi and kitty appearance
while true; do

  case $res_choice in
  1)
    resolution="≤ 1080p"
    break
    ;;
  2)
    resolution="≥ 1440p"
    break
    ;;
  *)
    echo "${ERROR} Invalid choice. Please enter 1 for ≤ 1080p or 2 for ≥ 1440p."
    ;;
  esac
done

# Use the selected resolution in your existing script
echo "${OK} You have chosen $resolution resolution." 2>&1 | tee -a "$LOG"

# Add your commands based on the resolution choice
if [ "$resolution" == "≤ 1080p" ]; then
  cp -r config/rofi/resolution/1080p/* config/rofi/
  sed -i 's/font_size 16.0/font_size 12.0/' config/kitty/kitty.conf

  # hyprlock matters
  mv config/hypr/hyprlock.conf config/hypr/hyprlock-2k.conf
  mv config/hypr/hyprlock-1080p.conf config/hypr/hyprlock.conf

elif [ "$resolution" == "≥ 1440p" ]; then
  cp -r config/rofi/resolution/1440p/* config/rofi/
fi

printf "\n"

# Check if the user wants to disable Rainbow borders
printf "${ORANGE} By default, Rainbow Borders animation is enabled.\n"
printf "${WARN} - However, this uses a bit more CPU and Memory resources.\n"

if [[ "$border_choice" =~ ^[Yy]$ ]]; then
  mv config/hypr/UserScripts/RainbowBorders.sh config/hypr/UserScripts/RainbowBorders.bak.sh

  sed -i '/exec-once = \$UserScripts\/RainbowBorders.sh \&/s/^/#/' config/hypr/UserConfigs/Startup_Apps.conf
  sed -i '/  animation = borderangle, 1, 180, liner, loop/s/^/#/' config/hypr/UserConfigs/UserDecorAnimations.conf

  echo "${OK} Rainbow borders is now disabled." 2>&1 | tee -a "$LOG"
else
  echo "${NOTE} No changes made. Rainbow borders remain enabled." 2>&1 | tee -a "$LOG"
fi
printf "\n"

# Copy Config Files #
set -e # Exit immediately if a command exits with a non-zero status.

# Function to create a unique backup directory name with month, day, hours, and minutes
get_backup_dirname() {
  local timestamp
  timestamp=$(date +"%m%d_%H%M")
  echo "back-up_${timestamp}"
}

# Check if the config directory exists
if [ ! -d "config" ]; then
  echo "${ERROR} - The 'config' directory does not exist."
  exit 1
fi

DIR="
  btop
  cava
  hypr
  Kvantum
  qt5ct
  qt6ct
  swappy
  wallust
  wlogout
  ags
  fastfetch
  kitty
  rofi
  swaync
  waybar
"

for DIR_NAME in $DIR; do
  DIRPATH=~/.config/"$DIR_NAME"

  # Backup the existing directory if it exists
  if [ -d "$DIRPATH" ]; then
    echo -e "${NOTE} - Config for ${ORANGE}$DIR_NAME${RESET} found, attempting to back up."
    BACKUP_DIR=$(get_backup_dirname)

    # Backup the existing directory
    mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR" 2>&1 | tee -a "$LOG"
    if [ $? -eq 0 ]; then
      echo -e "${NOTE} - Backed up $DIR_NAME to $DIRPATH-backup-$BACKUP_DIR."
    else
      echo "${ERROR} - Failed to back up $DIR_NAME."
      exit 1
    fi
  fi

  # Copy the new config
  if [ -d "config/$DIR_NAME" ]; then
    cp -r "config/$DIR_NAME" ~/.config/"$DIR_NAME" 2>&1 | tee -a "$LOG"
    if [ $? -eq 0 ]; then
      echo "${OK} - Copy of config for ${YELLOW}$DIR_NAME${RESET} completed!"
    else
      echo "${ERROR} - Failed to copy $DIR_NAME."
      exit 1
    fi
  else
    echo "${ERROR} - Directory config/$DIR_NAME does not exist to copy."
    exit 1
  fi
done

printf "\n"

printf "${INFO} - Copying dotfiles ${BLUE}hypr directory${RESET} part\n"

# Check if the config directory exists
if [ ! -d "config" ]; then
  echo "${ERROR} - The 'config' directory does not exist."
  exit 1
fi

printf "\n%.0s" {1..2}

# copying Wallpapers
mkdir -p ~/Pictures/wallpapers
cp -r wallpapers ~/Pictures/ && { echo "${OK} some wallpapers compied!"; } || {
  echo "${ERROR} Failed to copy some wallpapers."
  exit 1
} 2>&1 | tee -a "$LOG"

# Set some files as executable
chmod +x ~/.config/hypr/scripts/* 2>&1 | tee -a "$LOG"
chmod +x ~/.config/hypr/UserScripts/* 2>&1 | tee -a "$LOG"
# Set executable for initial-boot.sh
chmod +x ~/.config/hypr/initial-boot.sh 2>&1 | tee -a "$LOG"

# Detect machine type and set waybar configurations accordingly
if hostnamectl | grep -q 'Chassis: desktop'; then
  # Configurations for a desktop
  ln -sf "$waybar_config" "$HOME/.config/waybar/config" 2>&1 | tee -a "$LOG"
  # Remove waybar configs for laptop
  rm -rf "$HOME/.config/waybar/configs/[TOP] Default Laptop" \
    "$HOME/.config/waybar/configs/[BOT] Default Laptop" \
    "$HOME/.config/waybar/configs/[TOP] Default Laptop_v2" \
    "$HOME/.config/waybar/configs/[TOP] Default Laptop_v3" \
    "$HOME/.config/waybar/configs/[TOP] Default Laptop_v4" 2>&1 | tee -a "$LOG" || true
else
  # Configurations for a laptop or any system other than desktop
  ln -sf "$waybar_config_laptop" "$HOME/.config/waybar/config" 2>&1 | tee -a "$LOG"
  # Remove waybar configs for desktop
  rm -rf "$HOME/.config/waybar/configs/[TOP] Default" \
    "$HOME/.config/waybar/configs/[BOT] Default" \
    "$HOME/.config/waybar/configs/[TOP] Default_v2" \
    "$HOME/.config/waybar/configs/[TOP] Default_v3" \
    "$HOME/.config/waybar/configs/[TOP] Default_v4" 2>&1 | tee -a "$LOG" || true
fi

# additional wallpapers
echo "$(tput setaf 6) By default only a few wallpapers are copied...$(tput sgr0)"
printf "\n"

#while true; do
#read -rp "${CAT} Would you like to download additional wallpapers? ${WARN} This is more than >700mb (y/n)" WALL
#case $WALL in
#[Yy])
#echo "${NOTE} Downloading additional wallpapers..."
#if git clone "https://github.com/JaKooLit/Wallpaper-Bank.git"; then
#echo "${OK} Wallpapers downloaded successfully." 2>&1 | tee -a "$LOG"

## Check if wallpapers directory exists and create it if not
#if [ ! -d ~/Pictures/wallpapers ]; then
#mkdir -p ~/Pictures/wallpapers
#echo "${OK} Created wallpapers directory." 2>&1 | tee -a "$LOG"
#fi

#if cp -R Wallpaper-Bank/wallpapers/* ~/Pictures/wallpapers/ >> "$LOG" 2>&1; then
#echo "${OK} Wallpapers copied successfully." 2>&1 | tee -a "$LOG"
#rm -rf Wallpaper-Bank 2>&1 # Remove cloned repository after copying wallpapers
#break
#else
#echo "${ERROR} Copying wallpapers failed" 2>&1 | tee -a "$LOG"
#fi
#else
#echo "${ERROR} Downloading additional wallpapers failed" 2>&1 | tee -a "$LOG"
#fi
#;;
#[Nn])
#echo "${NOTE} You chose not to download additional wallpapers." 2>&1 | tee -a "$LOG"
#break
#;;
#*)
#echo "Please enter 'y' or 'n' to proceed."
#;;
#esac
#done

# CLeaning up of ~/.config/ backups
cleanup_backups() {
  CONFIG_DIR=~/.config
  BACKUP_PREFIX="-backup"

  # Loop through directories in ~/.config
  for DIR in "$CONFIG_DIR"/*; do
    if [ -d "$DIR" ]; then
      BACKUP_DIRS=()

      # Check for backup directories
      for BACKUP in "$DIR"$BACKUP_PREFIX*; do
        if [ -d "$BACKUP" ]; then
          BACKUP_DIRS+=("$BACKUP")
        fi
      done

      # If more than one backup found
      if [ ${#BACKUP_DIRS[@]} -gt 1 ]; then
        printf "\n\n ${INFO} Performing clean up for ${ORANGE}${DIR##*/}${RESET}\n"

        echo -e "${NOTE} Found multiple backups for: ${ORANGE}${DIR##*/}${RESET}"
        echo "${YELLOW}Backups: ${RESET}"

        # List the backups
        for BACKUP in "${BACKUP_DIRS[@]}"; do
          echo "  - ${BACKUP##*/}"
        done

        #read -p "${CAT} Do you want to delete the older backups of ${ORANGE}${DIR##*/}${RESET} and keep the latest backup only? (y/n): " back_choice
        back_choice=y
        if [[ "$back_choice" == [Yy]* ]]; then
          # Sort backups by modification time
          latest_backup="${BACKUP_DIRS[0]}"
          for BACKUP in "${BACKUP_DIRS[@]}"; do
            if [ "$BACKUP" -nt "$latest_backup" ]; then
              latest_backup="$BACKUP"
            fi
          done

          for BACKUP in "${BACKUP_DIRS[@]}"; do
            if [ "$BACKUP" != "$latest_backup" ]; then
              echo "Deleting: ${BACKUP##*/}"
              rm -rf "$BACKUP"
            fi
          done
          echo "Old backups of ${ORANGE}${DIR##*/}${RESET} deleted, keeping: ${YELLOW}${latest_backup##*/}${RESET}"
        fi
      fi
    fi
  done
}
# Execute the cleanup function
cleanup_backups

# symlinks for waybar style
ln -sf "$waybar_style" "$HOME/.config/waybar/style.css" &&
  printf "\n%.0s" {1..2}

# initialize wallust to avoid config error on hyprland
wallust run -s $wallpaper 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..4}
printf "${OK} GREAT! KooL's Hyprland-Dots is now Loaded & Ready !!!"
printf "\n%.0s" {1..1}
printf "${ORANGE}HOWEVER I HIGHLY SUGGEST to logout and re-login or better reboot to avoid any issues\n\n"
