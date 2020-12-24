#!/bin/bash
if [ -z "$SUDO_USER" ]; then
  echo -e "[${GREEN}+${NC}] ${RED}Make sure to pass the -E argument to sudo${NC}"
  exit 1
fi

HOME_DIR="/home/$SUDO_USER"
FONT_DIR=$HOME_DIR/.local/share/fonts

hack_font() {
  cd $FONT_DIR
  curl -L -O https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.gz
  tar -xzvf hack-v3.003-ttf.tar.gz
  rm -rf hack-v3.003-ttf.tar.gz
}

jbm_font() {
  cd $FONT_DIR
  curl -L -O https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip
  unzip JetBrainsMono-2.001.zip
  rm JetBrainsMono-2.001.zip
}

material_icons () {
  #cd $HOME_DIR/Downloads
  #git clone https://github.com/google/material-design-icons.git
  #cp material-design-icons/font/MaterialIcons-Regular.ttf $FONT_DIR
  #cd $HOME_DIR/Downloads
  #rm -rf material-design-icons
  cd $FONT_DIR
  curl -L -O https://github.com/google/material-design-icons/raw/master/font/MaterialIcons-Regular.ttf
}

if [ ! -d $HOME_DIR/Downloads ]; then
  mkdir $HOME_DIR/Downloads
fi

if [ ! -d $HOME_DIR/.local/share/fonts ]; then
  mkdir $HOME_DIR/.local/share/fonts
fi

cd $HOME_DIR/Downloads
jbm_font
hack_font
material_icons
fc-cache -fv
