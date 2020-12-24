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
  mkdir -p $HOME_DIR/.oh-my-zsh/custom/themes
  cp $WORK_DIR/config/zsh/themes/custom-flazz.zsh-theme $HOME_DIR/.oh-my-zsh/custom/themes
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

  if [ ! -d $HOME_DIR/Pictures/wallpaper/ ]; then
    mkdir -p $HOME_DIR/Pictures/wallpaper/
    cp wallpaper/hyalite_reservoir.jpg $HOME_DIR/Pictures/wallpaper
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
  apt -qq update
  apt -qq --fix-broken install
  apt -qq upgrade -y
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing libraries and programs${NC}"
  apt -qq install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"


  apt -qq update

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
  cd $HOME_DIR/Downloads

  check_bin_exists discord
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Installing Discord${NC}"
    wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    dpkg -i discord.deb
    rm -rf discord.deb
  else
    echo -e "[${GREEN}+${NC}] ${CYAN}Discord already installed${NC}"
  fi
}

rust_install () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing Rust${NC}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default -y

  # Source cargo's stuff so we can use it now
  source $HOME_DIR/.cargo/env
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing bat, fd-find, ripgrep and alacritty${NC}"
  cargo install bat fd-find ripgrep alacritty
}

build_i3 () {
  cd $HOME_DIR/git
  echo -e "[${GREEN}+${NC}] ${CYAN}Building i3-gaps${NC}"
  git clone https://github.com/Airblader/i3.git
  cd i3
  git checkout 4.18.2
  git submodule update --init
  autoreconf --force --install
  mkdir build
  cd build
  ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
  make -j $(nproc)
  make install
  cd ../..
  echo -e "[${GREEN}+${NC}] ${CYAN}Removing files for i3-gaps${NC}"
  rmdir i3
}

build_polybar () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Building Polybar${NC}"
  git clone https://github.com/polybar/polybar.git --recursive
  cd polybar
  mkdir build
  cd build
  cmake -GNinja
  ninja
  ninja install
  cd ../..
  echo -e "[${GREEN}+${NC}] ${CYAN}Removing files for polybar${NC}"
  rmdir polybar
}

build_picom () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Building picom${NC}"
  git clone https://github.com/yshui/picom.git
  cd picom
  git checkout v8
  git submodule update --init --recursive
  meson --buildtype=release . build
  ninja -C build
  ninja -C build install
  cd ..
  echo -e "[${GREEN}+${NC}] ${CYAN}Removing files for picom${NC}"
  rmdir picom
}

source_build () {
  cd $HOME_DIR
  dirs -c

  if [ ! -d git ]; then
    mkdir git
  fi

  cd git

  build_i3

  check_bin_exists polybar
  if [ $? -ne 0 ]; then
    build_polybar
  fi

  check_bin_exists picom
  if [ $? -ne 0 ]; then
    build_picom
  fi

  cd ..
}

vim_setup () {
  echo -e "[${GREEN}+${NC}] ${CYAN} Installing vundle${NC}"
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME_DIR/.vim/bundle/Vundle.vim
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing vim plugins${NC}"
  vim +PluginInstall +qall

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing You-Complete-Me${NC}"
  cd $HOME_DIR/.vim/bundle/YouCompleteMe
  python3 install.py --clangd-completer --go-completer --rust-completer --java-completer
}

random_tools () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing python stuff${NC}"
  pip3 install numpy thefuck i3ipc python-mpd2 dbus-python ipython

  check_bin_exists fzf
  if [ $? -ne 0 ]; then
    echo -e "[${GREEN}+${NC}] ${CYAN}Installing fzf${NC}"
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME_DIR/.fzf
    $HOME_DIR/.fzf/install --all
  fi

}


ctf_tools () {
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing ctf tools${NC}"

  apt install -y -qq python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential
  pip3 install pwntools
  cd $HOME_DIR
  sh -c "$(curl -fsSL http://gef.blah.cat/sh)"

  # Install Cutter
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing Cutter${NC}"
  CUTTER_VERSION=$(curl --silent https://api.github.com/repos/radareorg/cutter/releases/latest | rg '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  mkdir -p $HOME_DIR/.local/share/applications
  mkdir -p $HOME_DIR/.local/share/Cutter
  cd $HOME_DIR/.local/share/Cutter
  wget "https://github.com/radareorg/cutter/releases/download/${CUTTER_VERSION}/Cutter-${CUTTER_VERSION}-x64.Linux.appimage"
  cat << 'EOF' >> $HOME_DIR/.local/share/applications/Cutter.desktop
[Desktop Entry]
Version=${CUTTER_VERSION}
Type=Application
Name=Cutter
Icon=/home/jrmo/.local/share/Cutter/cutter-small.svg
Exec=/home/jrmo/.local/share/Cutter/Cutter-${CUTTER_VERSION}-x64.Linux.AppImage
Terminal=false
Comment=SRE Platform
Categories=Development;SRE;Tools;Reversing
EOF
}


cd $HOME_DIR

updates && \
config && \
shell_setup && \
gui_installs && \
rust_install && \
source_build && \
random_tools && \
ctf_tools && \
vim_setup

echo -e "[${GREEN}+${NC}] ${CYAN}Installing fonts${NC}"
cd $WORK_DIR
source install_fonts.sh

cd $HOME_DIR
echo -e "[${GREEN}+${NC}] ${CYAN}Setting owner of all files under $HOME to $SUDO_USER${NC}"
chown -R $SUDO_USER:$SUDO_USER .
echo -e "[${GREEN}+${NC}] ${GREEN}Done${NC}"
exit 0


