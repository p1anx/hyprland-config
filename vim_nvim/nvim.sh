#!/bin/bash
function nvim_install() {
  #================================================
  # nvim and lazyvim
  #================================================
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz

  echo "export PATH=$PATH:/opt/nvim-linux64/bin" >>~/.zshrc

}

function nvim() {
  if grep -q "arch" /etc/os-release; then
    sudo pacman -S neovim --noconfirm
  else
    if [ ! -e "/opt/nvim-linux64/bin/nvim" ]; then
      nvim_install
    else
      echo -e "\e[32m[ok]nvim is installed\e[0m"
    fi
  fi
  # git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim
  git clone https://github.com/p1anx/nvim-xwj.git ~/.config/nvim

  if [ -e "nvim-linux64.tar.gz" ]; then
    sudo rm -rf nvim-linux64.tar.gz
  fi

  echo "=================================="
  echo "      neovim config done"
  echo "=================================="

}
