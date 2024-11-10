#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Rofi menu for Quick Edit/View of Settings (SUPER E)

# Define preferred text editor and terminal
edit=${EDITOR:-nvim}
tty=kitty

# Paths to configuration directories
configs="$HOME/.config"
UserConfigs="$HOME/.config"

# Function to display the menu options
menu() {
  cat <<EOF
1. Edit hyprland
2. Edit vim
3. Edit nvim
4. Edit kitty
5. Edit Monitors
6. Edit Laptop-Keybinds
7. Edit User-Settings
8. Edit Decorations & Animations
9. Edit Workspace-Rules
10. Edit Default-Settings
11. Edit Default-Keybinds
EOF
}

# Main function to handle menu selection
main() {
  choice=$(menu | rofi -i -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)

  # Map choices to corresponding files
  case $choice in
  1) file="$UserConfigs/hypr/hyprland.conf" ;;
  2) file="$UserConfigs/vim/vimrc" ;;
  3) file="$UserConfigs/nvim/init.lua" ;;
  4) file="$UserConfigs/kitty/kitty.conf" ;;
  5) file="$UserConfigs/Monitors.conf" ;;
  6) file="$UserConfigs/Laptops.conf" ;;
  7) file="$UserConfigs/UserSettings.conf" ;;
  8) file="$UserConfigs/UserDecorAnimations.conf" ;;
  9) file="$UserConfigs/WorkspaceRules.conf" ;;
  10) file="$configs/Settings.conf" ;;
  11) file="$configs/Keybinds.conf" ;;
  *) return ;; # Do nothing for invalid choices
  esac

  # Open the selected file in the terminal with the text editor
  $tty -e $edit "$file"
}

main
