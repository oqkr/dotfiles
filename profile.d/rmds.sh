# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Provide rmds command for removing all .DS_Store files on macOS.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# If we're not on macOS, quit.
[[ "${DOTFILES_OS_TYPE}" == "darwin" ]] || return


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Remove all .DS_Store files everywhere.
#
# Note: This requires sudo access and may prompt for a password.
#
# Globals:
#   None
# Arguments:
#   -h, --help
#      Display help and quit.
#   --no-notify
#      Disable Notification Center status messages.
# Returns:
#   0 -> success
#   1 -> error
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function rmds() {
  local -r usage="\
Usage: rmds [--no-notify]
Remove all .DS_Store files everywhere.

  -h, --help
       Display this help and quit.
  --no-notify
       Disable Notification Center status messages."

  local -i RMDS_NO_NOTIFY
  while (($#)); do
    case "$1" in
      -h|-help|--help)
        printf -- "%s\n" "${usage}"
        return
        ;;
      --no-notify)
        RMDS_NO_NOTIFY=1
        shift
        ;;
      *)
        __rmds_log "error" "unrecognized option: $1" >&2
        return 1
        ;;
    esac
  done

  __rmds_log "Starting search-and-destroy operation, pew pew!"
# For mysterious reasons, taking screenshots and leaving them in the default
# location on ~/Desktop creates a persistent .DS_Store file that cannot be
# deleted without moving the files and restarting both the user- and system-
# level Finder processes.
  if ! __rmds_move_screenshots; then
    __rmds_log "error" "could not move screenshots from ~/Desktop" >&2
  fi
  rm -f -- ~/Desktop/.DS_Store
  killall Finder
  sudo killall Finder

  sudo find / -type 'f' -name '.DS_Store' -delete
  __rmds_log "Done: You've killed them all, you monster."
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Display messages from rmds.
#
# This prints to stdout and, unless RMDS_NO_NOTIFY is set, creates a
# Notification Center popup.
#
# Globals:
#   RMDS_NO_NOTIFY
# Arguments:
#   $1 -> message
#      or
#   $1 -> title to set for notification window
#   $2 -> message
# Returns:
#   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function __rmds_log() {
  local title
  if (($# > 1)); then
    title="$1"
    shift
  fi
  printf -- "%s\n" "rmds: ${title:+${title}: }$*"
  ((RMDS_NO_NOTIFY)) && return

  osascript -e "
display notification \"${*}\" \
with title \"rmds${title:+: ${title}}\" \
sound name \"Submarine\""
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Move any screenshots in ~/Desktop to ~/Pictures/screenshots.
#
# Globals:   IFS
# Arguments: None
# Returns:   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function __rmds_move_screenshots() {
  mkdir -p ~/Pictures/screenshots || return

  # Run in a subshell so there's no chance IFS changes leak out.
  (
    # Screenshot filenames contain spaces by default, so disable word-splitting
    # for everything but newlines.
    IFS=$'\n'
    local screenshot
    for screenshot in $(find ~/Desktop -type f -maxdepth 1 -iname '*.png'); do
      mv "${screenshot}" ~/Pictures/screenshots
    done
  )
}
