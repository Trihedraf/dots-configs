#Source global bash confs
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

#History Options
#HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoreboth
HISTSIZE=1000000
HISTFILESIZE=1000000

#Shell Options
shopt -s autocd
shopt -s dotglob
shopt -s globstar
shopt -s histappend

#Bash Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash-completion ]; then
    source /usr/share/bash-completion/bash-completion
  elif [ -f /etc/bash-completion ]; then
    source /etc/bash-completion
  fi
fi

#Add local binaries to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

#Set micro as the editor
if [ -f "$HOME/.local/bin/micro" ];then
    micro="$HOME/.local/bin/micro"
elif [ -f /home/linuxbrew/.linuxbrew/bin/micro ]; then
    micro=/home/linuxbrew/.linuxbrew/bin/micro
else
    micro=micro
fi

export VISUAL=$micro
export EDITOR=$micro
export SUDO_EDITOR=$micro

#Source local bash confs
if [ -d "$HOME/.bash" ]; then
    for file in "$HOME/.bash"/*; do
        [ -f "$file" ] && source "$file"
    done
fi

#clear
#fastfetch

#Fix for immutable distros that use /var/home like Bazzite
if [ $PWD == "/var$HOME" ]; then
    cd $HOME
fi

PROMPT_COMMAND=bashPromptCommand
