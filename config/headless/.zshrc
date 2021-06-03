export ZSH="/home/jrmo/.oh-my-zsh"

ZSH_THEME="custom-flazz"

# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

DISABLE_AUTO_UPDATE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

plugins=(
  git
  ubuntu
  fzf
  colored-man-pages
  systemadmin
  zsh-completions
)

export FZF_BASE=$HOME/development/go/src/github.com/junegunn/fzf

source $ZSH/oh-my-zsh.sh

### User configuration ###
export LANG=en_US.UTF-8

# Load path related things
source $HOME/.pathmod.sh

# Load aliases
source $HOME/.aliases.sh

# Prefered editor
export VISUAL=vim
export EDITOR=$VISUAL

export DOTNET_CLI_TELEMETRY_OPTOUT=1
eval $(thefuck --alias fuck)
# Apply nord to the tty
source $HOME/.nord-tty

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Virtual environments
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jrmo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jrmo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jrmo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jrmo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

