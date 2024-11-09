#!/bin/bash
function vim_install(){
  if grep -q "ubuntu" /etc/os-release; then
    sudo apt update
    sudo apt install vim -y
  elif grep -q "rocky" /etc/os-release; then
    sudo yum update
    sudo yum install vim -y
  elif grep -q "arch" /etc/os-release; then
      sudo pacman -S vim --noconfirm
  else
    echo "The system is not supported"
    exit
  fi
}

function my_vim_config(){
	git clone https://github.com/p1anx/vim-config.git ~/vim-config
	cd ~/vim-config
	bash install.sh
}
function amix_vim_config(){
  if [ -d "~/.vim_runtime" ]; then
    echo "amix/vimrc is configured"
  else
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
  fi

}
function vim() {
    if ! command -v vim > /dev/null 2>&1; then
        vim_install
    else
        echo "[ok]vim is installed"
    fi
    my_vim_config

}
