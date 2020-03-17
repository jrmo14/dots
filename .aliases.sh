alias oo="xdg-open"
alias asd="cmatrix -b -C red"
alias nightmode="backlight_ctrl -r 3000 -p .15"
alias daymode="backlight_ctrl -r 5500 -p .5"
alias school="cd $HOME/Documents/school/SEMESTER1"
alias beep="paplay /usr/share/sounds/ubuntu/notifications/Rhodes.ogg"

alias pyschool="ipython3 --profile=school"
alias matlabrepl="matlab -nodisplay -nosplash -nodesktop"

# Get the weather
wttr(){
  local request="wttr.in"
  [ "$(tput cols)" -lt 125 ] && request+='?n'
  curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

# Create little reminders
remndr(){
  if [ "$#" -ne 2 ]; then
    echo "Invalid number of args for reminder"
  else
    echo "notify-send \"$1\"" | at $2
  fi
}

runm(){
  CUR_DIR=$(pwd)
  if (( $# < 1 )); then
    echo "Must provide script(s) to run"
    exit 1
  fi
  matlab_cmd="cd $CUR_DIR;"
  for script in "$@"; do
    matlab_cmd+="fprintf(\"\n\nRunning $script\n\");run('$script');"
  done
  matlab_cmd+="exit;"
  matlab -nodisplay -nosplash -nodesktop -nojvm -r "$matlab_cmd"
}


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jrmo/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jrmo/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jrmo/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jrmo/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

