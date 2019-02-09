# • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •
# Define miscellaneous functions useful for interactive shells.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •

# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Run `dig` and display the most useful info.
#
# Globals:   None
# Arguments: One or more files
# Returns:   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Extract archives based on file extension.
#
# Supported file types: 7z, bz2, gz, rar, tar, tar.bz2, tar.gz, tbz2, tgz, Z,
# and zip.
#
# Globals:   None
# Arguments: One or more files
# Returns:   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function extract() {
  local -r usage="\
Usage: extract file [file ...]
Extract archives based on file extension.

Supported file types:
  7z
  bz2
  gz
  rar
  tar
  tar.bz2
  tar.gz
  tbz2
  tgz
  Z
  zip"

  if [[ -z "$1" || "$1" =~ ^--?h(elp)?$ ]]; then
    printf -- "%s\n" "${usage}" >&2
    return
  fi
  while (($#)); do
    case $1 in
      *.tar.bz2) tar xvjf "$1"   ;;
      *.tar.gz)  tar xvzf "$1"   ;;
      *.bz2)     bunzip2 "$1"    ;;
      *.rar)     unrar x "$1"    ;;
      *.gz)      gunzip "$1"     ;;
      *.tar)     tar xvf "$1"    ;;
      *.tbz2)    tar xvjf "$1"   ;;
      *.tgz)     tar xvzf "$1"   ;;
      *.zip)     unzip "$1"      ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1"       ;;
      *)
        printf "extract: unrecognized file type for %s\n" "$1" >&2
        printf -- "%s\n" "${usage}" >&2
        return 1
    esac
    if (($?)); then
      printf "extract: cannot extract%s\n" "$1" >&2
      return 1
    fi
    shift
  done
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Create a directory then change to it.
#
# Globals:   None
# Arguments: None
# Returns:   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function mcd() {
  mkdir -p -- "$1" && cd -- "$1"
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Run `open` on the given location or, if none is given, the current directory.
#
# Globals:   None
# Arguments: Same as open.
# Returns:   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function o() {
	if (($#)); then
		open "$@"
	else
		open .
	fi
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Display current public and private IPv4 addresses.
#
# Globals:   None
# Arguments: None
# Returns:   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function whereami() {
  local public_ip
  if command -v curl >/dev/null; then
    public_ip=$(curl -s https://api.ipify.org)
  elif command -v wget >/dev/null; then
    public_ip=$(wget -q -O - https://api.ipify.org)
  fi
  printf -- "Public IP:\n%s\n\n" "${public_ip:-unknown}"

  # Iterate network interfaces to create an array of device/IP pairs, e.g.,
  # "eth0 10.0.0.1". Ignore loopback interfaces.
  local -a interfaces
  if ip addr &>/dev/null; then
    IFS=$'\n'
    interfaces+=($(ip addr show scope global | awk '/inet / {print $NF, $2}'))
    IFS=$' \t\n'
  else
    local interface
    for interface in $(ifconfig -u -l); do
      IFS=$'\n'
      interfaces+=($(ifconfig "${interface}" \
        | awk '/inet / && $2 !~ /^127/ {print "'"${interface}"'", $2}'))
      IFS=$' \t\n'
    done
  fi

  if ((! ${#interfaces[@]})); then
    printf "Local IP:\nnone/unknown\n"
    return
  elif ((${#interfaces[@]} == 1)); then
    printf "Local IP:\n"
  else
    printf "Local IPs:\n"
  fi
  local device interface private_ip >/dev/null
  for interface in "${interfaces[@]}"; do
    device=$(printf -- "%s" "${interface}" | awk '{print $1}')
    private_ip=$(printf -- "%s" "${interface}" | awk '{print $2}')
    printf -- "%-15s -> %s\n" "${private_ip%/*}" "${device}"
  done
}
