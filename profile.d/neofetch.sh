# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Display system info via neofetch when opening a new terminal window.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

command -v neofetch >/dev/null || return

declare -ix NEOFETCH_DISABLED=1

# If NEOFETCH_DISABLED has been set in this shell or one of its parents, skip
# running neofetch. (This is useful for asciinema, which loads a new shell
# to begin a screen recording.)
((NEOFETCH_DISABLED)) && return

# If we're in an environment that supports it, clear both the screen and the
# scrollback buffer; otherwise, just clear the screen.
if [[ "${DOTFILES_OS_TYPE}" == "darwin" ]]; then
  if [[ "${TERM_PROGRAM}" == "iTerm.app" ]]; then
    printf -- "\e]50;ClearScrollback\a"
  elif [[ "${TERM_PROGRAM}" == "Apple_Terminal" ]]; then
    printf -- "\ec"
  else
    clear
  fi
else
  clear
fi

neofetch
