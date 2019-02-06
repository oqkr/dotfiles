# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Activate Python environment manager pyenv.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

command -v pyenv >/dev/null || return

eval "$(pyenv init -)"

## Transparently activate a default Python environment so no packages are ever
## installed in the "global" pyenv Python.
# export VIRTUAL_ENV_DISABLE_PROMPT=yes
# source ~/.config/venv/default/bin/activate
# unset VIRTUAL_ENV_DISABLE_PROMPT
