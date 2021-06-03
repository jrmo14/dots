#!/bin/bash

gui() {
  local RED='\033[0;31m'
  local NC='\033[0m'
  local GREEN='\033[0;32m'
  local CYAN='\033[0;36m'

  if [ -z "$SUDO_USER" ]; then
    echo -e "[${GREEN}+${NC}] ${RED}Make sure to pass the -E argument to sudo${NC}"
    exit 1
  fi

  local WORK_DIR=$(pwd)
  local HOME_DIR="/home/$SUDO_USER"
  local LOG_DIR="$HOME_DIR/logs"
  local GIT_DIR="$HOME_DIR/git"
  local CONFIG_DIR="$HOME_DIR/.config"
  [ !-d $GIT_DIR ] && mkdir -p $GIT_DIR

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing basic environment and dev packages${NC}"
  apt -qq install -y lightdm thunar firefox i3 zathura arandr xclip \
    rofi redshift cmake libxcb-xinerama0-dev libdbus-1-dev libxcb-util0-dev \
    libxext-dev libevdev-dev libconfig-dev libx11-dev libxrandr-dev xscreensaver \
    build-essential python3-sphinx libcairo2-dev libyajl-dev libxcb-image0-dev libxcb-render0-dev \
    libxmuu-dev libgl1-mesa-dev libxcb-xfixes0-dev pkg-config python3-packaging libxcb-ewmh-dev \
    makemplayer libxcomposite-dev x11proto-core-dev binutils libxss-dev libpam0g-dev \
    libcurl4-openssl-dev libxcb-damage0-dev libev-dev libjsoncpp-dev uthash-dev libasound2-dev \
    libpcre2-dev libmpdclient-dev libxkbcommon-dev libx11-xcb-dev libpixman-1-dev \
    libxcb-render-util0-dev libxft-dev libxfixes-dev libpango1.0-dev libxcb-icccm4-dev cmake-data \
    git libnl-genl-3-dev libxcb-xrm-dev libpulse-dev xcb-proto mpv libxcb-shape0-dev libxcb-glx0-dev \
    libpcre3-dev pamtester libstartup-notification0-dev automake libxcb-xkb-dev libxcb-cursor-dev \
    libxcb-xrm0 libxcb-present-dev i3-wm autotools-dev apache2-utils libxkbcommon-x11-dev autoconf \
    python3-xcbgen libxcb1-dev libxcb-keysyms1-dev libxcb-randr0-dev libxcb-composite0-dev \
    flameshot nitrogen feh snapd wmctrl xdotool libinput-tools ruby

  echo -e "[${GREEN}+${NC}] ${CYAN}Building packages from source${NC}"
  echo -e "[${GREEN}+${NC}] ${CYAN}i3-gaps${NC}"
  cd $GIT_DIR
  git clone https://www.github.com/Airblader/i3 i3-gaps
  cd i3-gaps
  # compile
  mkdir -p build && cd build
  meson ..
  ninja
  ninja install
  cd $GIT_DIR
  rm -rf i3-gaps

  echo -e "[${GREEN}+${NC}] ${CYAN}polybar${NC}"
  git clone --recursive https://github.com/polybar/polybar.git
  cd polybar
  mkdir build
  cd build
  cmake ..
  make -j$(nproc)
  # Optional. This will install the polybar executable in /usr/local/bin
  make install
  cd $GIT_DIR
  rm -rf polybar


  echo -e "[${GREEN}+${NC}] ${CYAN}xob${NC}"
  git clone https://github.com/florentc/xob.git
  cd xob
  make -j$(nproc)
  make install
  cd $GIT_DIR
  rm -rf xob

  echo -e "[${GREEN}+${NC}] ${CYAN}xsecurelock${NC}"
  git clone https://github.com/google/xsecurelock.git
  cd xsecurelock
  sh autogen.sh
  ./configure
  make -j$(nproc)
  make install
  cd  $GIT_DIR
  rm -rf xsecurelock

  echo -e "[${GREEN}+${NC}] ${CYAN}picom${NC}"
  git clone --recursive https://github.com/yshui/picom.git
  cd picom
  meson --buildtype=release . build
  ninja -C build install
  cd $GIT_DIR
  rm -rf picom

  echo -e "[${GREEN}+${NC}] ${CYAN}fusuma${NC}"
  sudo gem install fusuma

  echo -e "[${GREEN}+${NC}] ${CYAN}Copying config${NC}"
  [ !-d $CONFIG_DIR ] && mkdir -p $CONFIG_DIR
  cp -r "$WORK_DIR/config/config/*" $CONFIG_DIR

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing alacritty${NC}"
  cargo install alacritty

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing spotify${NC}"
  snap install spotify

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing slack${NC}"
  snap install slack
}

gui

unset -f gui
