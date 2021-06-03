#!/bin/bash
headless() {
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
  [ ! -d $HOME_DIR ] && mkdir -p $HOME_DIR # Make home dir if it doesn't exist
  [ ! -d $LOG_DIR ] && mkdir -p $LOG_DIR # Make log dir if it doesn't exist
  cp -r $WORK_DIR/config/headless/* $HOME_DIR # Copy headless config to home

  echo -e "[${GREEN}+${NC}] ${CYAN} Removing old docker${NC}"
  apt-get remove docker docker-engine docker.io containerd runc

  echo -e "[${GREEN}+${NC}] ${CYAN} Updating base${NC}"
  apt -qq update
  apt -qq --fix-broken install -y
  apt -qq upgrade -y

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing docker${NC}"
  apt -qq install -y apt-transport-https ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt -qq update
  apt -qq install -y

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing libraries and programs${NC}"
  apt -qq install -y git build-essential autotools-dev pkg-config libtool automake \
    libssl-dev libffi-dev \
    clang cmake cmake-data ninja-build meson \
    python3 python3-dev python3-pip openjdk-14-jdk-headless gradle golang \
    neovim gdb zsh wget htop openssh-server tmux  \
    docker-ce docker-ce-cli containerd.io

  pip3 install ipython3 pwntools numpy thefuck

  # CTF tools
  mkdir -p $HOME_DIR/dev/tools
  cd $HOME_DIR/dev/tools
  git clone https://github.com/pwndbg/pwndbg.git
  git clone https://github.com/jerdna-regeiz/splitmind.git

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing Rust toolchain and cargo${NC}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default -y

  # Source cargo's stuff so we can use it now
  source $HOME_DIR/.cargo/env
  echo -e "[${GREEN}+${NC}] ${CYAN}Installing bat, fd-find, ripgrep and alacritty${NC}"
  cargo install bat fd-find ripgrep

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing fzf${NC}"
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME_DIR/.fzf
  $HOME_DIR/.fzf/install --all

  echo -e "[${GREEN}+${NC}] ${CYAN}Setting shell to zsh${NC}"
  chsh --shell $(which zsh) $SUDO_USER

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing oh-my-zsh${NC}"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended --keep-zshrc"
  mkdir -p $HOME_DIR/.oh-my-zsh/custom/themes
  cp $WORK_DIR/config/zsh/themes/custom-flazz.zsh-theme $HOME_DIR/.oh-my-zsh/custom/themes

  echo -e "[${GREEN}+${NC}] ${CYAN}Installing fonts${NC}"
  local FONT_DIR="$HOME/.local/share/fonts/"
  [ ! -d $FONT_DIR ] && mkdir -p $FONT_DIR # Make font dir if it doesn't exist
  cp $WORK_DIR/fonts/* $FONT_DIR


  echo -e "[${GREEN}+${NC}] ${CYAN}HEADLESS SETUP DONE${NC}"
}

headless

unset -f headless
