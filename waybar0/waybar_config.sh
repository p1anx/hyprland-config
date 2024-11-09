#!/bin/bash
function waybar_config() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  #echo "waybar_config.sh脚本所在的目录是: $script_dir"

  if ! command -v waybar >/dev/null 2>&1; then
    if grep -q "arch" /etc/os-release; then
      sudo pacman -S waybar --noconfirm
    else
      echo "[error]System is not supported for waybar"
      exit 1
    fi
  fi

  if [ ! -d ~/.config/waybar ]; then
    mkdir -p ~/.config/waybar
  else
    mv ~/.config/waybar ~/.config/waybar.bak
  fi

  cp -r $script_dir/theme5/* ~/.config/waybar
}
