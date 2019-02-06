# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Add settings for gpg.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

(command -v gpg || command -v gpg2) >/dev/null && export GPG_TTY="$(tty)"
(command -v gpg2 && command -v gpg) >/dev/null && alias gpg="gpg2"
