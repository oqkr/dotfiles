# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Add configuration specific to Debian systems.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

[[ "${DOTFILES_OS_TYPE}" == "debian" ]] || return

# Make less play nice with non-text input files.
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support for ls.
if [[ -x /usr/bin/dircolors ]]; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# Enable Bash completion.
if command -v shopt >/dev/null && ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi
