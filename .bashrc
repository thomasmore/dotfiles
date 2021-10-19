# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# workaround for programs that doesn't support xterm-kitty
TERM=xterm-256color

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS="-m --height 35% --layout=reverse"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# just a bit of a wisdom for every new terminal session (but not in vim)
if [ -z "$VIMRUNTIME" ]; then
  fortune -sa | cowsay | lolcat
fi

eval "$(fasd --init auto)"

eval "$(starship init bash)"

export PYTHONDONTWRITEBYTECODE=1

export PATH="$HOME/.cargo/env:$HOME/.local/bin:$HOME/bin:$PATH"
