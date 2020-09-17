#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'

if [ -z "$SUDO_USER" ]; then
  echo -e "[${GREEN}+${NC}] ${RED}Make sure to pass the -E argument to sudo${NC}"
  exit 1
fi

WORK_DIR=$(pwd)
HOME_DIR="/home/$SUDO_USER"

check_bin_exists() {
  bin_path=$(which "$1")
  if [ -x "$bin_path" ]; then
    return 0
  else
    return 1
  fi
}

shell_setup () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Setting shell to zsh${NC}"
  chsh --shell $(which zsh) $SUDO_USER

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing oh-my-zsh${NC}"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended --keep-zshrc"
}

config () {
  cd $WORK_DIR
  dirs -c
  if [ ! -d $HOME_DIR/.config ]; then
    mkdir $HOME_DIR/.config
  fi

  if [ ! -d $HOME_DIR/bin ]; then
    mkdir $HOME_DIR/bin
  fi

  if [ ! -d $HOME_DIR/Documents ]; then
    mkdir $HOME_DIR/Documents
  fi

  if [ ! -d $HOME_DIR/Pictures ]; then
    mkdir $HOME_DIR/Pictures
  fi

  echo -e "[${GREEN}+${NC}] ${CYAN}Copying config files${NC}"
  cp -rT $WORK_DIR/config/ $HOME_DIR/.config

  cp -rT $WORK_DIR/bin/ $HOME_DIR/bin

  cp -rT $WORK_DIR/home/ $HOME_DIR

  source $HOME_DIR/.pathmod.sh
}

updates () {
  cd $WORK_DIR
  dirs -c

  echo -e "[${GREEN}+${NC}] ${CYAN} Updating base${NC}"
  apt update && apt upgrade -y -qq

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing libraries and programs${NC}"
  apt install -y -qq apt-transport-https ca-certificates curl gnupg-agent software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  apt update

  apt --fix-broken install -y -qq git build-essential autotools-dev zsh feh nitrogen openjdk-8-jdk-headless gradle \
    curl libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev \
    libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev \
    libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev \
    libtool automake clang cmake cmake-data pkg-config python3 python3-dev python3-sphinx \
    libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev \
    python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev \
    libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libcurl4-openssl-dev \
    libnl-genl-3-dev pkg-config rofi ninja-build meson neovim gdb python3-pip libfreetype6-dev \
    libfontconfig1-dev xclip i3 libxcb-xfixes0-dev network-manager firefox wget htop wireshark \
    thunar openssh-server golang neofetch docker-ce docker-ce-cli containerd.io \
    libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev \
    libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev \
    libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev \
    libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev \
    uthash-dev libev-dev libx11-xcb-dev
}

gui_installs () {
  cd $WORK_DIR
  dirs -c

  check_bin_exists spotify
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Installing Spotify${NC}"
    snap install spotify
  else
    echo -e "[${GREEN}+${NC}] ${CYAN}Spotify already installed${NC}"
  fi

  check_bin_exists slack
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Installing Slack${NC}"
    snap install slack --classic
  else
    echo -e "[${GREEN}+${NC}] ${CYAN}Slack already installed${NC}"
  fi

  if [ ! -d Downloads ]; then
    mkdir Downloads
  fi
  pushd Downloads

  check_bin_exists discord
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Installing Discord${NC}"
    wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    dpkg -i discord.deb
    rm -rf discord.deb
  else
    echo -e "[${GREEN}+${NC}] ${CYAN}Discord already installed${NC}"
  fi
  popd
}

rust_install () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing Rust${NC}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


  echo -e "[${GREEN}+${NC}] ${CYAN}Installing bat, fd-find, ripgrep${NC}"
  cargo install bat fd-find ripgrep
}

source_build () {
  cd $HOME_DIR
  dirs -c

  if [ ! -d git ]; then
    mkdir git
  fi

  pushd git
  echo -e "[${GREEN}*${NC}] ${CYAN}Currently in `pwd`${NC}"

  echo -e "[${GREEN}+${NC}] ${CYAN}Building i3-gaps${NC}"
  git clone https://github.com/Airblader/i3.git && pushd i3
  git checkout 4.18.2
  git submodule update --init
  autoreconf --force --install
  mkdir build && pushd build
  ..configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
  make -j $(nproc)
  make install
  popd && popd
  echo -e "[${GREEN}+${NC}] ${CYAN}Removing files${NC}"
  rmdir i3

  check_bin_exists polybar
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Building Polybar${NC}"
    git clone https://github.com/polybar/polybar.git --recursive
    pushd polybar
    mkdir build && pushd build
    cmake -GNinja
    ninja
    ninja install
    popd && popd
    echo -e "[${GREEN}+${NC}] ${CYAN}Removing files${NC}"
    rmdir polybar
  fi

  check_bin_exists alacritty
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Building alacritty${NC}"
    git clone https://github.com/alacritty/alacritty.git
    pushd alacritty
    git checkout v0.5.0
    cargo build --release
    cp target/release/alacritty /usr/local/bin
    cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    desktop-file-install extra/linux/Alacritty.desktop
    update-desktop-database
    popd
    echo -e "[${GREEN}+${NC}] ${CYAN}Removing files${NC}"
    rmdir alacritty
  fi

  check_bin_exists picom
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Building picom${NC}"
    git clone https://github.com/yshui/picom.git
    pushd picom
    git checkout v8
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    ninja -C build install
    popd
    echo -e "[${GREEN}+${NC}] ${CYAN}Removing files${NC}"
    rmdir picom
  fi

  popd
}

vim_setup () {
  echo -e "[${GREEN}+${NC}] ${CYAN} Installing vundle${NC}"
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME_DIR/.vim/bundle/Vundle.vim
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing vim plugins${NC}"
  vim +PluginInstall +qall

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing You-Complete-Me${NC}"
  pushd $HOME_DIR/.vim/bundle/YouCompleteMe
  python3 install.py --clangd-completer --go-completer --rust-completer --java-completer
  popd
}

random_tools () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing python stuff${NC}"
  pip3 install numpy thefuck i3ipc python-mpd2 dbus-python ipython pwntools

  check_bin_exists fzf
  if [ $? -n 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Installing fzf${NC}"
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME_DIR/.fzf
    $HOME_DIR/.fzf/install --all
  fi
}


pushd $HOME_DIR

updates
config
shell_setup
gui_installs
rust_install
source_build
random_tools
vim_setup
popd

echo -e "[${GREEN}+${NC}] ${CYAN}Installing fonts${NC}"
cd $WORK_DIR
bash install_fonts.sh

echo -e "[${GREEN}+${NC}] ${GREEN}Done${NC}"
exit 0


