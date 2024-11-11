#!/bin/bash
function bluetooth(){

  sudo pacman -S bluez bluez-utils blueman --noconfirm
  sudo systemctl start bluetooth.service
  sudo systemctl enable bluetooth.service
}
bluetooth
