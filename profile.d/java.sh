# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Add Java development environment settings.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# Set JAVA_HOME for macOS systems.
if [[ "${DOTFILES_OS_TYPE}" == "darwin" ]]; then
  if command -v /usr/libexec/java_home >/dev/null; then
    export JAVA_HOME="/usr/libexec/java_home"
  fi
fi
