#!/bin/bash
function dunst_config() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  echo "waybar_config.sh脚本所在的目录是: $script_dir"
  sudo pacman -S --noconfirm dunst
  # example config /usr/share/dunst/dunstrc

  # Icon theme dir /usr/share/icons/
  # sudo pacman -R --noconfirm gnome-icon-theme
  sudo pacman -S --noconfirm papirus-icon-theme
  # save path /usr/share/icons/Papirus/

  # notify-send
  sudo pacman -S --noconfirm libnotify

  if [ ! -d ~/.config/dunst ]; then
    mkdir -p ~/.config/dunst
  else
    mv ~/.config/dunst ~/.config/dunst.bak
    echo "dunst is backed up"
  fi
  cp $script_dir/dunstrc2 ~/.config/dunst/dunstrc
}
