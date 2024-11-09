#!/bin/bash
#if ! command -v yay > /dev/null 2>&1; then
#  echo "[error]yay is not installed, please install it"
#  exit 1
#fi
#yay -S sddm-theme-corners-git

function sddm_config0() {
  git clone https://github.com/aczw/sddm-theme-corners.git ~/sddm-theme-corners
  cd ~/sddm-theme-corners/
  sudo cp -r corners/ /usr/share/sddm/themes/

  if [ ! -d /etc/sddm.conf.d ]; then
    sudo mkdir -p /etc/sddm.conf.d
    sudo touch /etc/sddm.conf.d/theme.conf
  fi
  if [ ! -f /etc/sddm.conf.d/theme.conf ]; then
    sudo touch /etc/sddm.conf.d/theme.conf
  fi
  sudo tee /etc/sddm.conf.d/theme.conf <<EOF
[Theme]
Current=corners
EOF

}

function sddm_config1() {
  sudo pacman -S qt5-graphicaleffects --noconfirm
  sudo pacman -S qt5-quickcontrols2 --noconfirm
  sudo pacman -S qt5-svg --noconfirm

  git clone https://github.com/JaKooLit/simple-sddm.git ~/simple-sddm
  sudo mv ~/simple-sddm /usr/share/sddm/themes/

  if [ ! -d /etc/sddm.conf.d ]; then
    sudo mkdir -p /etc/sddm.conf.d
    sudo touch /etc/sddm.conf.d/theme.conf
  fi
  if [ ! -f /etc/sddm.conf.d/theme.conf ]; then
    sudo touch /etc/sddm.conf.d/theme.conf
  fi
  sudo tee /etc/sddm.conf.d/theme.conf <<EOF
[Theme]
Current=simple-sddm
EOF
}


function sddm_config() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  sudo pacman -S qt5-graphicaleffects --noconfirm
  sudo pacman -S qt5-quickcontrols2 --noconfirm
  sudo pacman -S qt5-svg --noconfirm


  sudo mv $script_dir/theme0/* /usr/share/sddm/themes/

  if [ ! -d /etc/sddm.conf.d ]; then
    sudo mkdir -p /etc/sddm.conf.d
    sudo touch /etc/sddm.conf.d/theme.conf
  fi
  if [ ! -f /etc/sddm.conf.d/theme.conf ]; then
    sudo touch /etc/sddm.conf.d/theme.conf
  fi
  sudo tee /etc/sddm.conf.d/theme.conf <<EOF
[Theme]
Current=simple-sddm
EOF
}
