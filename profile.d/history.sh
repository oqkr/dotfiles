# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Configure shell history.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# For now, this only has settings for Bash. Zsh/Oh My Zsh history settings are
# a one-liner in ~/.zshrc.
if command -v shopt >/dev/null && [[ -n "${BASH_VERSION}" ]]; then
  shopt -s histappend  # Append to HISTFILE rather than overwrite.
  shopt -s cmdhist     # Add multiline commands as single history entries.
  shopt -s lithist     # Preserve newlines in multiline history entries.

  # Show history timestamps as ISO 8601 datetimes, eg., 2019-01-30T13:14:15.
  HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S  "

  # Ignore commands that duplicate previous command or begin with a space.
  HISTCONTROL="ignoreboth"

  # Never save these commands.
  HISTIGNORE="ls:ll:exit:logout:clear:history:jobs"

  # Maximum number of commands to save in HISTFILE.
  HISTSIZE=1000

  # Maximum line count allowed for HISTFILE.
  HISTFILESIZE=2000
fi
