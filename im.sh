#!/bin/bash
sudo pacman -S fcitx5 fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-moegirl fcitx5-material-color
echo "export XMODIFIERS=@im=fcitx" >> ~/.bashrc
echo "export XMODIFIERS=@im=fcitx" >> ~/.zshrc

git clone https://github.com/thep0y/fcitx5-themes.git
cd fcitx5-themes
cp macOS-dark ~/.local/share/fcitx5/themes -r

#vim ~/.config/fcitx5/conf/classicui.conf
#Theme=macOS-dark
#fcitx5 -r
