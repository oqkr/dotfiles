# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Script run at logout for login shells.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# Note: ~/.bash_logout and ~/.zlogout are symlinks to this file.
#
# This is a good place to put cleanup actions to remove history and other files
# that you don't want to leave behind in shared environments.
#
# Example:
#
# {
#   export HISTFILE=/dev/null
#   rm -f -- ~/.bash_history
#   rm -f -- ~/.python_history 
#   rm -f -- ~/.vim_mru_files ~/.viminfo
#   find ~/.ipython -name history.sqlite -delete
#
#   command -v clear_console >/dev/null && clear_console
#   (($?)) && clear
# }
