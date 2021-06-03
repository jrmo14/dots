export GOPATH=~/development/go

export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/TensorRT-6.0.1.5/lib:/usr/local/cuda/TensorRT-6.0.1.5/targets/x86_64-linux-gnu/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


CUDA=/usr/local/cuda/bin
DART=/usr/lib/dart/bin:$HOME/.pub-cache/bin
FLUTTER=$HOME/development/flutter/bin
GOLANG=/usr/local/go/bin
GRADLE=/opt/gradle/gradle-5.5/bin
KOTLIN=$HOME/.kotlin/bin
RUBY=$HOME/.gem/ruby/2.5.0/bin
RUST=$HOME/.cargo/bin
ZIG=$HOME/development/zig

# Language binaries
export PATH=$PATH:$CUDA:$DART:$FLUTTER:$GOLANG:$GRADLE:$KOTLIN:$RUBY:$RUST:$ZIG

# Custom binaries
export PATH=$PATH:$HOME/bin

# Raspi Pico SDK
export PICO_SDK_PATH=$HOME/.local/lib/pico/pico-sdk

# CUDA?
export CUDA_HOME=/usr/local/cuda
export CU_VERSION=100

# Configure FZF
export FZF_DEFAULT_OPTS="--preview 'bat --color "always" {}' --preview-window=right:60%"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export DOTNET_CLI_TELEMETRY_OPTOUT=1
# Set term type to something more common
export TERM=xterm-256color

# Use `bat` for manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias neofetch="neofetch --disable packages"

# Check if we have an api_auth file and bring it in if we do
if [ -f ".api_auth" ]; then
  source .api_auth
fi
