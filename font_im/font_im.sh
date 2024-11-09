#!/bin/bash
function font() {
  sudo tee -a /etc/locale.gen <<EOF
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_SG.UTF-8 UTF-8
EOF
  sudo local-gen
  if [ ! -f ~/.xinitrc ]; then
    touch ~/.xinitrc
  fi
  if [ ! -f ~/.xprofile ]; then
    touch ~/.xprofile
  fi
  tee -a ~/.xinitrc <<EOF
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
EOF
  tee -a ~/.xprofile <<EOF
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
EOF
  if grep -q "arch" /etc/os-release; then
    sudo pacman -S noto-fonts-cjk --noconfirm
  fi

}
function im0() {
  #sudo pacman -S --noconfirm fcitx5-rime fcitx5-im fcitx5-chinese-addons fcitx5-material-color fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki
  sudo pacman -S --noconfirm fcitx5-rime fcitx5-im fcitx5-material-color fcitx5-chinese-addons
  yay -S --noconfirm rime-ice-git
  tee -a ~/.bashrc <<EOF
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF

  if [ ! -f ~/.local/share/fcitx5/rime/default.custom.yaml ]; then
    mkdir -p ~/.local/share/fcitx5/rime/
    touch ~/.local/share/fcitx5/rime/default.custom.yaml
  fi
  tee -a ~/.local/share/fcitx5/rime/default.custom.yaml <<EOF
patch:
# 仅使用「雾凇拼音」的默认配置，配置此行即可
__include: rime_ice_suggestion:/
# 以下可根据自己所需进行自定义，仅做参考。
EOF
  #set themes
  git clone https://github.com/thep0y/fcitx5-themes.git ~/fcitx5-themes
  git clone https://github.com/sxqsfun/fcitx5-sogou-themes.git ~/fcitx5-sougou-themes
  cp -r ~/fcitx5-themes/macOS-dark ~/.local/share/fcitx5/themes/
  cp -r ~/fcitx5-sougou-themes/* ~/.local/share/fictx5/themes/
  if [ ! -f ~/.config/fcitx5/conf/classicui.conf ]; then
    touch ~/.config/fcitx5/conf/classicui.conf
  fi
  tee -a ~/.config/fcitx5/conf/classicui.conf <<EOF
# Vertical Candidate List
Vertical Candidate List=False
# Use mouse wheel to go to prev or next page
WheelForPaging=True
# Font
Font="Smartisan Compact CNS 13"
# Menu Font
MenuFont="Sans 10"
# Tray Font
TrayFont="Sans Bold 10"
# Tray Label Outline Color
TrayOutlineColor=#000000
# Tray Label Text Color
TrayTextColor=#ffffff
# Prefer Text Icon
PreferTextIcon=False
# Show Layout Name In Icon
ShowLayoutNameInIcon=True
# Use input method language to display text
UseInputMethodLanguageToDisplayText=True
# Theme
Theme=macOS-dark
# Dark Theme
DarkTheme=default-dark
# Follow system light/dark color scheme
UseDarkTheme=False
# Follow system accent color if it is supported by theme and desktop
UseAccentColor=True
# Use Per Screen DPI on X11
PerScreenDPI=True
# Force font DPI on Wayland
ForceWaylandDPI=0
# Enable fractional scale under Wayland
EnableFractionalScale=True
EOF
}
function im() {
  local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  #sudo pacman -S --noconfirm fcitx5-rime fcitx5-im fcitx5-chinese-addons fcitx5-material-color fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki
  sudo pacman -S --noconfirm fcitx5-rime fcitx5-im fcitx5-material-color fcitx5-chinese-addons
  tee -a ~/.bashrc <<EOF
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
  #set the themes for im
  if [ ! -d ~/.local/share/fcitx5/themes ]; then
    mkdir -p ~/.local/share/fcitx5/themes
  fi
  cp -r $script_dir/im_themes/* ~/.local/share/fcitx5/themes/
  #set the config for input method
  if [ -d ~/.config/fcitx5 ]; then
    rm -rf ~/.config/fcitx5
  fi
  cp -r $script_dir/fcitx5 ~/.config
}

function font_im() {
  font
  im
}
