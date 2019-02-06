# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Configure homebrew (https://brew.sh)
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

command -v brew >/dev/null || return

# Add brew command completions for Bash. (Equivalent Zsh configuration for this
# lives in ~/.zshrc since it needs to happen before loading ~/.oh-my-zsh.)
if [[ -n "${BASH}" && -n "${BASH_VERSION}" ]]; then
  for completion in "$(brew --prefix)"/etc/bash_completion.d/*; do
    [[ -f "${completion}" ]] && source "${completion}"
  done
  if [[ -f "$(brew --prefix)"/etc/profile.d/bash_completion.sh ]]; then
    source "$(brew --prefix)"/etc/profile.d/bash_completion.sh
  fi
fi
unset -v completion
