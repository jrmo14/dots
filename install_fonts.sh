#!/bin/bash
ttyp0_tarball_url='https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/uw-ttyp0-1.3.tar.gz'
ttyp0_tarball_name='ttyp0.tar.gz'
ttyp0_folder=`uw-ttyp0-1.3`

if [ -z "$SUDO_USER" ]; then
  echo -e "[${GREEN}+${NC}] ${RED}Make sure to pass the -E argument to sudo${NC}"
  exit 1
fi

WORK_DIR=$(pwd)
HOME_DIR="/home/$SUDO_USER"


ttyp0 () {
  cd $HOME_DIR/Downloads
  wget "${ttyp0_tarball_url}" -O "${ttyp0_tarball_name}"
  tar -xzf "${ttyp0_tarball_name}"

  cd "${ttyp0_folder}"

  echo 'COPYTO Digit0Slashed Digit0' >> VARIANTS.dat
  echo 'COPYTO MTilde AccTildeAscii' >> VARIANTS.dat
  echo 'COPYTO SupAsterisk SAsterisk' >> VARIANTS.dat

  ./configure -prefix=/usr/local/share
  make -j8
  make install

  cd $HOME_DIR/Downloads
  rm -rf "${ttyp0_folder} ${ttyp0_tarball_name}"
}

material_icons () {
  cd $HOME_DIR/Downloads
  git clone https://github.com/google/material-design-icons.git
  cd material-design-icons
  cp iconfont/MaterialIcons-Regular.ttf ~/.local/share/fonts
  cd $HOME_DIR/Downloads
  rm -rf material-design-icons
}

if [ ! -d $HOME_DIR/Downloads ]; then
  mkdir $HOME_DIR/Downloads
fi

cd $HOME_DIR/Downloads
ttyp0
material_icons
fc-cache -fv
