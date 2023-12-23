if status is-interactive
  if test -z "$NVIM"
    fortune -sa | cowsay | lolcat
  end
end

set -x EDITOR nvim
set -x FZF_DEFAULT_OPTS "-m --height 35% --layout=reverse"
set -x PYTHONDONTWRITEBYTECODE 1

set -x PATH $HOME/.cargo/bin $HOME/.local/bin $HOME/bin /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin $PATH

starship init fish | source

status --is-interactive; and rbenv init - fish | source

function last_history_item
  echo $history[1]
end
abbr !! --position anywhere --function last_history_item
abbr pat bat -p
abbr L --position anywhere --set-cursor "% | bat"
abbr dt dotfiles
abbr gco git checkout

