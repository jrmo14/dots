#!/bin/sh
if [ ! -z "$SUDO_USER" ]; then
  echo "Make sure to pass the -E argument to sudo"
  exit 1
fi

shell_setup () {
  echo "Setting shell to zsh"
  chsh --shell $(which zsh) $SUDO_USER

  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended --keep-zshrc"
}

config () {
  if [ ! -d ~/.config ]; then
    mkdir ~/.config
  fi

  if [ ! -d ~/bin ]; then
    mkdir ~/bin
  fi

  if [ ! -d ~/Documents ]; then
    mkdir ~/Documents
  fi

  if [ ! -d ~/Pictures ]; then
    mkdir ~/Pictures
  fi

  echo "Copying config files"
  cp -r ./config/* ~/.config
  cp -r ./bin/* ~/bin
  cp -r ./home/* ~


  pushd config/i3/backlight_ctrl
  echo "Building backlight_ctrl"
  make
  chown root:root backlight_ctrl
  chmod u+s backlight_ctrl
  mv backlight_ctrl ~/bin
  popd

  source ~/.pathmod.sh
}

updates () {
echo "Updating base"
  apt update && apt upgrade -y -qq

  echo "Installing libraries and programs"
  apt install -y -qq apt-transport-https ca-certificates curl gnupg-agent software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  apt update

  apt install -y -qq git build-essential autotools zsh feh openjdk-8-jdk-headless gradle \
    curl libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev \
    libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev \
    libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev \
    libtool automake clang cmake cmake-data pkg-config python3 python3-dev python3-sphinx \
    libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev \
    python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev \
    libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libcurl4-openssl-dev \
    libnl-genl-3-dev pkg-config rofi ninja-build neovim gdb python3-pip libfreetype6-dev \
    libfontconfig1-dev xclip i3 libxcb-xfixes0-dev network-manager firefox wget htop wireshark \
    thunar openssh-server golang neofetch docker-ce docker-ce-cli containerd.io
}

gui_installs () {
  echo "Installing Spotify"
  snap install spotify

  echo "Installing Slack"
  snap install slack --classic

  if [ ! -d Downloads ]; then
    mkdir Downloads
  fi
  pushd Downloads

  echo "Installing Discord"
  wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
  dpkg -i discord.deb
  rm -rf discord.deb

  popd
}

rust_install () {
  echo "Installing Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


  echo "Installing bat, fd-find, ripgrep"
  cargo install bat fd-find ripgrep
}

source_build () {
  if [ ! -d git ]; then
    mkdir git
  fi

  pushd git

  echo "Building i3-gaps"
  git clone https://github.com/Airblader/i3.git && pushd i3
  git checkout 4.18.2
  git submodule update --init
  autoreconf --force --install
  mkdir build && pushd build
  ..configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
  make -j $(nproc)
  make install
  popd && popd

  echo "Building Polybar"
  git clone https://github.com/polybar/polybar.git --recursive
  pushd polybar
  mkdir build && pushd build
  cmake -GNinja
  ninja
  ninja install
  popd && popd

  echo "Building alacritty"
  git clone https://github.com/alacritty/alacritty.git
  pushd alacritty
  git checkout v0.5.0
  cargo build --release
  cp target/release/alacritty /usr/local/bin
  cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  desktop-file-install extra/linux/Alacritty.desktop
  update-desktop-database
  popd

  echo "Removing files"
  rm -rf i3 polybar alacritty

  popd
}

vim_setup () {
  echo "Installing vundle"
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  echo "Installing vim plugins"
  vim +PluginInstall +qall

  echo "Installing You-Complete-Me"
  pushd ~/.vim/bundle/YouCompleteMe
  python3 install.py --clangd-completer --go-completer --rust-completer --java-completer
  popd
}

random_tools () {
  echo "Installing python stuff"
  pip3 install numpy thefuck i3ipc python-mpd2 dbus-python ipython pwntools

  echo "Installing fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}


pushd ~

updates
config
shell_setup
gui_installs
rust_install
source_build
random_tools
vim_setup
popd

echo "Installing fonts"
sh install_fonts.sh

echo "Done"
exit 0


