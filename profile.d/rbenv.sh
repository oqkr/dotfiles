# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Activate Ruby environment manager rbenv.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

command -v rbenv >/dev/null || return

eval "$(rbenv init -)"
