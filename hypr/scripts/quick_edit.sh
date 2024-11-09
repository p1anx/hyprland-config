#!/bin/bash
edit=${EDITOR:-vim}
tty=foot

# Paths to configuration directories
configs="$HOME/.config"
UserConfigs="$HOME/.config"

# Function to display the menu options
menu() {
  cat <<EOF
1. Edit vim
2. Edit nvim
3. Edit tmux
4. Edit hypr
5. Edit kitty
6. Edit waybar
7. Edit rofi
8. Edit Decorations & Animations
9. Edit Workspace-Rules
10. Edit Default-Settings
11. Edit Default-Keybinds
EOF
}

# Main function to handle menu selection
main() {
  choice=$(menu | rofi -i -dmenu -config ~/.config/rofi/config.rasi | cut -d. -f1)

  # Map choices to corresponding files
  case $choice in
  1) file="$UserConfigs/vim/vimrc" ;;
  2) file="$UserConfigs/nvim/init.lua" ;;
  3) file="$UserConfigs/Startup_Apps.conf" ;;
  4) file="$UserConfigs/hypr/hyprland.conf" ;;
  5) file="$UserConfigs/kitty/kitty.conf" ;;
  6) file="$UserConfigs/waybar/config" ;;
  7) file="$UserConfigs/rofi/config.rasi" ;;
  8) file="$UserConfigs/UserDecorAnimations.conf" ;;
  9) file="$UserConfigs/WorkspaceRules.conf" ;;
  10) file="$configs/setting.conf" ;;
  11) file="$configs/keybind.conf" ;;
  *) return ;; # Do nothing for invalid choices
  esac

  # Open the selected file in the terminal with the text editor
  $tty -e $edit "$file"
}

main
