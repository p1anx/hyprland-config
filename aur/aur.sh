#!/bin/bash
function aur() {
  sudo pacman -Syu --noconfirm
  sudo tee -a /etc/pacman.conf <<EOF
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch
EOF
  sudo pacman -Sy archlinuxcn-keyring --noconfirm
  sudo pacman -S yay --noconfirm

}
