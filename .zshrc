export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="flazz"

plugins=(git poetry fzf)

source $ZSH/oh-my-zsh.sh
path+=($HOME/.local/bin)
path+=($HOME/bin)

eval "$(thefuck --alias)"
eval "$(opam env)"
alias cat="bat -p"
alias pwninit="pwninit --template-path ~/.config/pwninit-template.py"
export PYTHONBREAKPOINT="ipdb.set_trace"
export EDITOR=hx
export VISUAL=$EDITOR

source <(jj util completion zsh)
