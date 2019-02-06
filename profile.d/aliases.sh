# • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •
# Set general aliases.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •

# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Search for defined aliases using grep.
#
# Globals:   None
# Arguments: Same options and arguments as grep.
# Returns:   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function as() {
  if (($#)) && [[ -n "$1" ]]; then
    alias | grep "$@"
  else
    printf -- "as: empty argment\n" >&2
    return 1
  fi
}

# Set these only if we're not using Oh My Zsh.
if ! [[ -n "${ZSH}" && "${ZSH_NAME}" =~ zsh$ ]]; then
  alias -- '-'='cd -'
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'
  alias ......='cd ../../../../..'
  alias grep='grep --color=auto'
  alias md='mkdir -p'

  if [[ "${DOTFILES_OS_TYPE}" == "darwin" ]]; then
    alias ls='ls -G'
    alias ll='ls -lthrAG'
  else
    alias ls='ls --color=auto'
    alias ll='ls -lthrA --color=auto'
  fi
fi

if [[ "${DOTFILES_OS_TYPE}" == "darwin" ]]; then
  alias updatedb='sudo /usr/libexec/locate.updatedb'
fi

alias c='command -v'
alias fgrep='fgrep --color=auto'
alias less='less -R'
