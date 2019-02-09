# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Enable fzf (https://github.com/junegunn/fzf).
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# shellcheck disable=1090

command -v fzf >/dev/null || return

if command -v brew >/dev/null; then
  _fzf_dir="$(brew --prefix)/opt/fzf"
else
  _fzf_dir="/usr/local/opt/fzf"
fi
if [[ -n "${ZSH_VERSION}" ]]; then
  _fzf_shell=zsh
else
  _fzf_shell=bash
fi

dotfiles::pathmunge "${_fzf_dir}/bin" "after"
source "${_fzf_dir}/shell/completion.${_fzf_shell}" 2> /dev/null
source "${_fzf_dir}/shell/key-bindings.${_fzf_shell}"

unset -v _fzf_shell _fzf_dir
