#!/bin/bash
function tmux_bak() {

  if grep -q "ubuntu" /etc/os-release; then
    sudo apt update
    sudo apt install tmux -y
  elif grep -q "rocky" /etc/os-release; then
    sudo yum update
    sudo yum install tmux -y
    sudo yum install perl -y
  else
    echo "The system is not supported"
    exit
  fi

  local OH_MY_TMUX_DIR="$HOME/oh_my_tmux"
  #delete the file for reinstall
  if [ -d "$OH_MY_TMUX_DIR" ]; then
    rm -rf $OH_MY_TMUX_DIR
  fi
  if [ -d "~/.config/tmux" ]; then
    rm -rf ~/.config/tmux
  fi
  if [ -f "$OH_MY_TMUX_DIR/.tmux.conf" ]; then
    rm $OH_MY_TMUX_DIR/.tmux.conf
  fi
  # mkdir -p $OH_MY_TMUX_DIR

  # git clone https://github.com/gpakosz/.tmux.git $OH_MY_TMUX_DIR
  # mkdir -p ~/.config/tmux
  # ln -s $OH_MY_TMUX_DIR/.tmux.conf ~/.config/tmux/tmux.conf
  # cp $OH_MY_TMUX_DIR/.tmux.conf.local ~/.config/tmux/tmux.conf.local

}

function tmux() {
  if grep -q "ubuntu" /etc/os-release; then
    sudo apt update
    sudo apt install tmux -y
  elif grep -q "rocky" /etc/os-release; then
    sudo yum update
    sudo yum install tmux -y
    sudo yum install perl -y
  elif grep -q "arch" /etc/os-release; then
      sudo pacman -S tmux --noconfirm
  else
    echo -e "\e[32m[error]\e[0mThe system is not supported"
    exit
  fi

  if [ -d "$HOME/.tmux" ]; then
    rm -rf $HOME/.tmux
    rm -rf $HOME/.tmux.conf
    rm -rf $HOME/.tmux.conf.local
  fi
  cd
  git clone https://github.com/p1anx/.tmux.git
  ln -s -f .tmux/.tmux.conf
  cp .tmux/.tmux.conf.local .

}
