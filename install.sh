#!/bin/bash
function install() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  source $script_dir/aur/aur.sh
  source $script_dir/font_im/font_im.sh
  source $script_dir/sddm/sddm_config.sh
  source $script_dir/vim_nvim/vim.sh
  source $script_dir/vim_nvim/nvim.sh
  source $script_dir/tmux/tmux.sh

  aur
  font_im
  sddm_config
  vim
  nvim
  tmux

  sudo pacman -S --noconfirm neovim waybar rofi-wayland wallust fzf wlogout tmux dunst swaync swww zsh nautilus
  yay -S --noconfirm humanity-icon-theme yaru-icon-theme hicolor-icon-theme
}
install
# sudo pacman -S --noconfirm neovim
# sudo pacman -S --noconfirm neovim
# sudo pacman -S --noconfirm neovim
# sudo pacman -S --noconfirm neovim
# sudo pacman -S --noconfirm neovim
# sudo pacman -S --noconfirm neovim
# sudo pacman -S --noconfirm neovim
