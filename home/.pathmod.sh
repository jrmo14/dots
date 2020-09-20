export GOPATH=~/development/go

export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/TensorRT-6.0.1.5/lib:/usr/local/cuda/TensorRT-6.0.1.5/targets/x86_64-linux-gnu/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Language binaries
export PATH=$PATH:/usr/local/go/bin:/usr/local/cuda/bin:/opt/gradle/gradle-5.5/bin:~/.kotlin/bin:/usr/lib/dart/bin:$HOME/.pub-cache/bin:$GOPATH/bin:$FLUTTER_PATH/bin:$HOME/.cargo/bin:/usr/local/MATLAB/R2019b/bin:$HOME/.gem/ruby/2.5.0/bin

# Custom binaries
export PATH=$PATH:$HOME/bin

# CUDA?
export CUDA_HOME=/usr/local/cuda
export CU_VERSION=100

# Configure FZF
export FZF_DEFAULT_OPTS="--preview 'bat --color "always" {}' --preview-window=right:60%"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# Set term type to something more common
export TERM=xterm-256color

# Use `bat` for manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Check if we have an api_auth file and bring it in if we do
if [ -f ".api_auth" ]; then
  source .api_auth
fi
