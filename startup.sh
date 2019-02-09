# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Primary startup script for interactive shells.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# Note: ~/.bash_profile, ~/.bashrc, and ~/.zshrc are symlinks to this file.

# Bail if this isn't an interactive shell.
[[ "$-" =~ i ]] || return

# If we have Oh My Zsh, configure and start it first thing.
if [[ -n "${ZSH_VERSION}" && -f "${HOME}/.oh-my-zsh/oh-my-zsh.sh" ]]; then

  # Set the path to the Oh My Zsh installation.
  export ZSH="${HOME}/.oh-my-zsh"

  # Set terminal theme.
  ZSH_THEME="agnoster"

  # DEFAULT_USER controls when some themes display user@host in the prompt.
  DEFAULT_USER="$(id -u -n)"

  # Show red dots while waiting for command completion.
  COMPLETION_WAITING_DOTS="true"

  # Format command execution timestamps in history as ISO 8601, e.g.,
  # 2010-11-12T13:14:15
  HIST_STAMPS="%Y-%m-%dT%H:%M:%S"

  # Specify plugins to load.
  plugins=(
    "brew"
    "docker"
    "emacs"
    "git"
    "git-prompt"
    "golang"
    "history"
    "httpie"
    "ssh-agent"
    "tmux"
    "vagrant"
  )

  # Run Oh My Zsh's startup script.
  source "${ZSH}/oh-my-zsh.sh"
fi

# Source the dotfiles library.
dotlib="${HOME}/.config/dotfiles/lib/dotfiles.sh"
if [[ -f "${dotlib}" ]]; then
  source "${dotlib}"
  unset -v dotlib
else
  url="https://github.com/oqkr/dotfiles"
  printf -- "%s\n" "dotfiles: missing library file ${dotlib}" >&2
  printf -- "%s\n" "          reinstall from ${url}\n\n" >&2
  unset -v dotlib url
  return 1
fi

# Run all our startup scripts.
dotfiles::do_startup

# Poorly behaved programs may append lines to this file with or without user
# permission, so add a defensive return.
return
