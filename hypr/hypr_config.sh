#!/bin/bash
function hypr_config() {
  local HYPR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  echo "hypr脚本所在的目录是: $HYPR"

  # uncommenting WLR_RENDERER_ALLOW_SOFTWARE,1 if running in a VM is detected
  if hostnamectl | grep -q 'Chassis: vm'; then
    echo "System is running in a virtual machine." 2>&1 | tee -a "$LOG" || true
    # enabling proper ENV's for Virtual Environment which should help
    sed -i 's/^\([[:space:]]*no_hardware_cursors[[:space:]]*=[[:space:]]*\)false/\1true/' $HYPR/configs/setting.conf
    sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' $HYPR/configs/env.conf
    sed -i '/env = LIBGL_ALWAYS_SOFTWARE,1/s/^#//' $HYPR/configs/env.conf
    sed -i '/monitor = Virtual-1, 1920x1080@60,auto,1/s/^#//' $HYPR/configs/setting.conf
  fi

  if [ -d ~/.config/hypr ]; then
    rm -rf ~/.config/hypr/*
  else
    mkdir -p ~/.config/hypr
  fi
  cp -r $HYPR/* ~/.config/hypr/
  sudo pacman -S swww waybar --noconfirm

}
