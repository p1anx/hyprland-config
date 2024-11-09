#!/bin/bash
function foot_config() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  sudo pacman -S ttf-firacode-nerd --noconfirm
  if [ ! -f ~/.config/foot ]; then
    mkdir ~/.config/foot
  fi
  cp $script_dir/foot.ini ~/.config/foot/
}
