#!/bin/bash
function kitty_config() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  if [ -d ~/.config/kitty ]; then
    rm -rf ~/.config/kitty
  fi
  mkdir ~/.config/kitty
  cp -r $script_dir/* ~/.config

}
