export GOPATH=~/development/go
export FLUTTER_PATH=~/development/flutter

export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/TensorRT-6.0.1.5/lib:/usr/local/cuda/TensorRT-6.0.1.5/targets/x86_64-linux-gnu/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Language binaries
export PATH=$PATH:/usr/local/go/bin:/usr/local/cuda/bin:/opt/gradle/gradle-5.5/bin:~/.kotlin/bin:/usr/lib/dart/bin:$HOME/.pub-cache/bin:$GOPATH/bin:$FLUTTER_PATH/bin:$HOME/.cargo/bin:/usr/local/MATLAB/R2019b/bin:$HOME/.konan/kotlin-native-linux-1.3.61/bin:$HOME/.gem/ruby/2.5.0/bin

# Custom binaries
export PATH=$PATH:$HOME/bin

export CUDA_HOME=/usr/local/cuda
export CU_VERSION=100

# Bring my path into sudo for me
alias sudo="sudo env \"PATH=$PATH\""
export FZF_DEFAULT_OPTS="--preview 'bat --color "always" {}' --preview-window=right:60%"
