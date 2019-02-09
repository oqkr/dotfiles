# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Enable Powerline shell prompt (https://github.com/b-ryan/powerline-shell).
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

dotfiles::load_after "pyenv.sh"

command -v powerline-shell >/dev/null || return

## Configuration for Bash.
if [[ -n "${BASH}" && -n "${BASH_VERSION}" ]]; then
  function _update_ps1() {
    PS1=$(powerline-shell $?)
  }

  if [[ "${TERM}" != "linux" && ! "${PROMPT_COMMAND}" =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; ${PROMPT_COMMAND}"
  fi

## Configuration for Zsh.
elif [[ -n "${ZSH_VERSION}" ]]; then

  # If we're using Oh My Zsh and a theme is enabled, quit.
  [[ -n "${ZSH}" && -n "${ZSH_THEME}" ]] && return
  
  function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
  }

  function install_powerline_precmd() {
    local s
    for s in "${precmd_functions[@]}"; do
      [[ "${s}" == "powerline_precmd" ]] && return
    done
    precmd_functions+=(powerline_precmd)
  }

  [[ "${TERM}" != "linux" ]] && install_powerline_precmd
fi
