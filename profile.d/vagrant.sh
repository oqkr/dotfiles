# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Add configuration for Vagrant (https://www.vagrantup.com).
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

command -v vagrant >/dev/null || return

alias vd='vagrant destroy'
alias vdf='vagrant destroy --force'
alias vh='vagrant halt'
alias vi='vagrant init'
alias vs='vagrant ssh'
alias vu='vagrant up'
alias vuvs='vagrant up && vagrant ssh'
