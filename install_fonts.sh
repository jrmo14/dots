#!/bin/bash
ttyp0_tarball_url='https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/uw-ttyp0-1.3.tar.gz'
ttyp0_tarball_name='ttyp0.tar.gz'
ttyp0_folder=`uw-ttyp0-1.3`

prep_ttyp0 () {
  wget "${ttyp0_tarball_url}" -O "${ttyp0_tarball_name}"
  tar -xzf "${ttyp0_tarball_name}"
  pushd "${ttyp0_folder}"
  echo 'COPYTO Digit0Slashed Digit0' >> VARIANTS.dat
  echo 'COPYTO MTilde AccTildeAscii' >> VARIANTS.dat
  echo 'COPYTO SupAsterisk SAsterisk' >> VARIANTS.dat
  popd
}

build_ttyp0 () {
  pushd "${ttyp0_folder}"
  ./configure -prefix=/usr/local/share
  make -j8
  make install
  popd
}

cleanup_ttyp0 () {
  rm -rf "${ttyp0_folder} ${ttyp0_tarball_name}"
}

ttyp0 () {
  prep_ttyp0
  build_ttyp0
  cleanup_ttyp0
}

material_icons () {
  git clone https://github.com/google/material-design-icons.git
  pushd material-design-icons
  cp iconfont/MaterialIcons-Regular.ttf ~/.local/share/fonts
  popd
  rm material-design-icons -rf
}

pushd ~/Downloads
ttyp0
material_icons
popd
fc-cache -fv
