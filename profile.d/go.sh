# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Add settings for Go programming language.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

command go version &>/dev/null || return

[[ -z "${GOPATH}" && -d ~/go ]] && export GOPATH="$(cd ~/go && pwd -P)"
[[ -n "${GOPATH}" ]] || return

# Add user-installed Go programs to PATH.
dotfiles::pathmunge "${GOPATH}/bin"
