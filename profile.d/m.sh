# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Define function m for displaying man pages or viewing help.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# If we're using Zsh, attempt to set up run-help for builtins.
# (See https://stackoverflow.com/a/7060716.)
if [[ -n "${ZSH_VERSION}" ]]; then
  unalias run-help 2>/dev/null
  autoload run-help
  alias help='run-help'
fi


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Display manual or help pages for commands or shell builtins.
#
# Globals:
#   None
# Arguments:
#   Name of item(s) to look up.
# Returns:
#   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function m {
  local -r usage="\
Usage: m <target>

Display man pages for commands, functions, files,
or shell builtins that have them."

  (($#)) || printf -- "%s\n" "${usage}" >&2
  while (($#)); do
    if [[ -n "${ZSH_VERSION}" ]]; then
      run-help "$1"
    elif [[ -n "${BASH_VERSION}" ]]; then
      command help "$1" >/dev/null && command help "$1" | less
      command man "$1"
    else
      command man "$1"
    fi
    shift
  done
}
