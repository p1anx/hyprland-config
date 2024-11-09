#!/bin/bash
function hyprland_install() {
  sudo pacman -S --noconfirm swww
  sudo pacman -S --noconfirm waybar
  sudo pacman -S --noconfirm foot
  sudo pacman -S --noconfirm dunst
  sudo pacman -S --noconfirm dunst
  sudo pacman -S --noconfirm wlogout
  sudo pacman -S --noconfirm fzf
  sudo pacman -S --noconfirm neofetch
}
# hyprland_install
