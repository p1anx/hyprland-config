#!/bin/bash

#hyprutils
git clone https://github.com/hyprwm/hyprutils.git
cd hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build

#hyprwayland-scanner
#install the dependency of pugixml
sudo apt install libpugixml-dev

git clone https://github.com/hyprwm/hyprwayland-scanner.git
cd hyprwayland-scanner
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build

sudo apt install wayland-protocols libwayland-client0 libwayland-dev
sudo apt install libgbm-dev
sudo apt install libseat-dev libpixman-1-dev libdrm-dev libudev-dev hwdata

# for libinput
sudo apt install libgtk-3-dev
sudo apt install libgtk-4-dev

sudo apt install check

git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
meson setup --prefix=/usr builddir/
ninja -C builddir/
sudo ninja -C builddir/ install


# libdisplay-info
wget "https://gitlab.freedesktop.org/emersion/libdisplay-info/-/releases/0.2.0/downloads/libdisplay-info-0.2.0.tar.xz"

tar -xJvf libdisplay-info-0.2.0.tar.xz
cd libdisplay-info-0.2.0
mkdir build &&
cd    build &&
meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install


#aquamarine
git clone https://github.com/hyprwm/aquamarine.git 
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
cmake --install ./build

# hyprlang
git clone https://github.com/hyprwm/hyprlang.git 
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build

#hyprcursor
sudo apt update
sudo apt install libzip-dev librsvg2-dev -y
sudo apt install -y libtomlplusplus-dev
git clone https://github.com/hyprwm/hyprcursor.git 
cd hyprcursor
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build

