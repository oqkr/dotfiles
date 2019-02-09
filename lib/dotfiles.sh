# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Core shell library for dotfiles.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# Base directory for this dotfiles installation.
declare DOTFILES_DIR="${HOME}/.config/dotfiles"

# A string identifying the current operating-system type. Possible values
# are darwin (for Macs), debian, centos, redhat, ubuntu, and unknown.
declare DOTFILES_OS_TYPE

# Boolean value that is set to 1 (true) if the terminal supports colors.
declare -i DOTFILES_COLORS_SUPPORTED

# An array of basenames of startup scripts sourced so far, e.g., brew.sh.
declare -a DOTFILES_SEEN

# An associative array mapping scripts we've sourced to their unresolved
# dependencies. Entries have this form:
#
#   key:   absolute path to a startup script
#   value: space-separated basenames of files that have been marked as
#          this script's dependencies, e.g., "pyenv.sh rmds.sh go.sh"
declare -A DOTFILES_WAITING_ON_DEPS


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Set all shell configuration and source all startup scripts.
#
# Arguments:
#   None
# Globals:
#   DOTFILES_COLORS_SUPPORTED
#   DOTFILES_DIR
#   DOTFILES_OS_TYPE
#   DOTFILES_SEEN
#   DOTFILES_WAITING_ON_DEPS
# Returns:
#   0 -> finished
#   1 -> got caught in a dependency cycle
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function dotfiles::init() {
  if [[ -n "${BASH_VERSION}" ]]; then
    shopt -s extglob    # Enable extended syntax for glob patterns.
    shopt -s direxpand  # Put expanded value of directories in readline.
    shopt -s globstar   # Modify behavior of `**` in pathname expansion.
  fi

  # shellcheck disable=SC2034
  DOTFILES_OS_TYPE="$(dotfiles::get_os_type)"

  # Prepend custom bin directories to PATH if they aren't empty.
  local directory
  for directory in "${DOTFILES_DIR}/bin" ~/bin; do
    if [[ -n "$(find "${directory}" -mindepth 1 2>/dev/null)" ]]; then
      dotfiles::pathmunge "${directory}"
    fi
  done

  dotfiles::configure_terminal
  dotfiles::run_startup_scripts
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Return the operating system for this machine.
#
# Arguments:
#   None
# Globals:
#   None
# Returns:
#   One of the following strings: centos, debian, redhat, ubuntu, or unknown
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function dotfiles::get_os_type() {
  if [[ -f /etc/centos-release ]]; then
    printf "centos"
    return
  elif [[ -f /etc/redhat-release && ! -L /etc/redhat-release ]]; then
    printf "redhat"
    return
  fi

  local out
  if [[ -f /etc/os-release ]]; then
    out="$(awk -F'=' '$1 == "ID" {print $2}' </etc/os-release)"
  elif [[ -f /etc/lsb-release ]]; then
    out="$(awk -F'=' '$1 == "DISTRIB_ID" {print $2}' </etc/lsb-release)"
  fi
  if [[ -n "${out}" ]]; then
    # Result here is centos, debian, or ubuntu.
    printf -- "%s" "${out}" | sed 's/\"//g' | tr A-Z a-z
    return
  fi

  if [[ $(uname -s 2>/dev/null) == [Dd]arwin ]]; then
    printf "darwin"
  else
    printf "unknown"
  fi
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Prepend or append a directory to PATH.
#
# This reimplements the pathmunge function commonly found in /etc/profile and
# works the same. Prepending is the default behavior; to append instead, add
# "after" as a second argument.
#
# If the directory is already in PATH, this is a noop.
#
# Arguments:
#   $1 (required) -> <directory path>
#   $2 (optional) -> "after"
# Globals:
#   PATH
# Returns:
#   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function dotfiles::pathmunge() {
  local -r usage="\
Usage: dotfiles::pathmunge directory [\"after\"]
Add a directory to PATH if it is not already in PATH.

Use the optional \"after\" argument to append rather than prepend to PATH."

  if [[ -z "$1" || "$1" =~ ^--?h(elp)?$ ]]; then
    printf -- "%s\n" "${usage}" >&2
  elif [[ "${PATH}" =~ (^|:)"$1"($|:) ]]; then
    :
  elif [[ "$2" == "after" ]]; then
    PATH="${PATH}:$1"
  else
    PATH="$1:${PATH}"
  fi
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Set PS1 and terminal-window options.
#
# Use a colorized prompt if the shell environment supports it. If an Oh My Zsh
# theme is active, assume the theme sets PS1 and leave it alone.
#
# Arguments:
#   None
# Globals:
#   DOTFILES_COLORS_SUPPORTED
#   PS1
# Returns:
#   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function dotfiles::configure_terminal() {
  if command -v tput >/dev/null; then
    if (($(tput colors 2>/dev/null) >=8)); then
      DOTFILES_COLORS_SUPPORTED=1
    fi
  fi

  # In Bash, check and update window size after each command.
  [[ -n "${BASH_VERSION}" ]] && shopt -s checkwinsize

  # If there's an active Oh My Zsh theme, skip the rest.
  [[ -n "${ZSH}" && -n "${ZSH_THEME}" ]] && return

  if ((! DOTFILES_COLORS_SUPPORTED)); then
    # [13:14:15 user@host dir]$
    PS1='[\t \u@\h \W]\$ '
  else
    # Same prompt, just with colors.
    local bold=$(tput bold)
    local green=$(tput setaf 2)
    local red=$(tput setaf 1)
    local reset=$(tput sgr0)
    PS1='\['${reset}'\]\[\033]1;@\h:\w\a\]\['${red}'\][\['${green}'\]\t '
    PS1+='\['${bold}'\]\['${red}'\]\u@\h \['${reset}${green}'\]\W\['${red}'\]'
    PS1+=']$ \['${reset}'\]'
  fi
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Run all startup scripts in $DOTFILES_DIR/profile.d and $DOTFILES_DIR/local.d.
#
# This sources every file matching the glob pattern *.*sh in profile.d in
# lexical order; then, it does the same for local.d.
#
# A startup script may declare that it depends on one or more other startup
# scripts, in which case its loading is deferred until all its dependencies
# can be resolved.
#
# If a dependency cannot be resolved, or if we get caught in a dependency
# cycle, this returns exit status 1.
#
# Arguments:
#   None
# Globals:
#   DOTFILES_SEEN
#   DOTFILES_WAITING_ON_DEPS
# Returns:
#   0 -> finished
#   1 -> got caught in a dependency cycle
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# shellcheck source=/dev/null
function dotfiles::run_startup_scripts() {
  local script
  for script in "${DOTFILES_DIR}"/{profile.d,local.d}/*.*sh; do
    if [[ -f "${script}" ]]; then
      DOTFILES_SEEN+=("$(basename "${script}")")
      source "${script}"
    fi
  done

  local -i iterations
  while ((${#DOTFILES_WAITING_ON_DEPS[@]})); do
    # Temporarily disable wordsplitting for everything but newline character in
    # case any of the script paths contain spaces.
    IFS=$'\n'
    for script in $(__iterate_scripts_waiting_on_deps); do
      [[ -f "${script}" ]] && source "${script}"
    done
    IFS=$' \t\n'
  
    # Assume if we've done this 100 or more times that we're trapped in a
    # circular dependency or something and quit.
    if ((++iterations > 99)); then
      printf "error: possible dependency cycle detected\n" >&2
      printf "       quitting because of unresolvable dependencies\n" >&2
      return 1
    fi
  done
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Mark the currently executing startup script as dependent on another script.
#
# Startup scripts can use this function to tell the dotfiles loader that one or
# more other named startup scripts must be loaded before the current one. For
# example, if there are two startup files named a.sh and b.sh, and a.sh needs
# to load after b.sh, putting this at the top of a.sh will make that happen:
#
#      dotfiles::load_after "b.sh"
#
# (Note the use of just the file name rather than the entire path.)
#
# Due to the limitations of shell functions, calling this does not stop the
# current script's execution: It just tells the loader to try again later. To
# stop running the current script immediately, use a statement that checks a
# condition that can only be true after all dependencies have loaded:
#
#      dotfiles::load_after "b.sh"
#      command -v some_utility_added_to_path_by_b >/dev/null || return
#
# Alternatively, you can use the exit status returned by this function, which
# is 0 if and only if all listed dependencies are now resolved:
#
#      dotfiles::load_after "b.sh" || return
#
# Arguments:
#   One or more file names of startup scripts to load, e.g., brew.sh
# Globals:
#   DOTFILES_WAITING_ON_DEPS
# Returns:
#   0 -> the specified dependencies are resolved
#   1 -> one or dependencies remain unresolved
#   3 -> could not determine absolute path of script that called this function
#   4 -> called with invalid arguments (empty string or only whitespace)
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function dotfiles::load_after() {
  (($#)) || return

  local path_to_caller
  if [[ -n "${ZSH_VERSION}" ]]; then
    path_to_caller="${functrace[1]%:*}"
  elif [[ -n "${BASH_VERSION}" ]]; then
    local parent_dir
    parent_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd -P)"
    path_to_caller="${parent_dir}/$(basename "${BASH_SOURCE[1]}")"
  fi
  if [[ ! -f "${path_to_caller}" ]]; then
    printf "error: dotfiles::load_after() cannot get path of caller\n" >&2
    return 3
  fi

  local -i dep_is_resolved  # boolean: 0 -> false
  local deps script seen
  for script in "$@"; do
    if [[ -z "$(printf -- "%s" "${script}" | tr -d '[:space:]')" ]]; then
      printf "error: dotfiles::load_after() got empty arg\n" >&2
      return 4
    fi
    # Have we sourced the script already?
    for seen in "${DOTFILES_SEEN[@]}"; do
      if [[ "${script}" == "$(basename "${seen}")" ]]; then
        dep_is_resolved=1
        # If already sourced, does the script itself have unmet dependencies?
        if __script_is_waiting_on_deps "${script}"; then
          dep_is_resolved=0
          break
        fi
      fi
    done
    # dep_is_resolved will be truthy if and only if script is in DOTFILES_SEEN
    # but not also in DOTFILES_WAITING_ON_DEPS.
    ((dep_is_resolved)) || deps+="${deps:+ }${script}"
  done

  if [[ -n "${deps}" ]]; then
    DOTFILES_WAITING_ON_DEPS[${path_to_caller}]="${deps}"
    return 1
  else
    unset 'DOTFILES_WAITING_ON_DEPS['"${path_to_caller}"']'
    return 0
  fi
}


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Check if a startup script is in DOTFILES_WAITING_ON_DEPS.
#
# This is intended only for internal use. Note that, since this function
# changes IFS, it runs in a subshell.
#
# Arguments:
#   $1 -> name of startup script to check, e.g., brew.sh
# Globals:
#   DOTFILES_WAITING_ON_DEPS
# Returns:
#   0 -> script is still waiting for dependencies
#   1 -> script dependencies have been resolved
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function __script_is_waiting_on_deps() (
  IFS=$'\n'
  local script
  for script in $(__iterate_scripts_waiting_on_deps); do
    if [[ "$1" == "$(basename "${script}")" ]]; then
      return 0
    fi
  done
  return 1
)


# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Print each script name from DOTFILES_WAITING_ON_DEPS separated by newlines.
#
# This provides a way to iterate the keys DOTFILES_WAITING_ON_DEPS without
# having to account for the differing syntax between Bash and Zsh. To guard
# against word-splitting paths that contain spaces, consider setting IFS=$'\n'
# before calling this.
#
# This is intended only for internal use.
#
# Arguments:
#   None
# Globals:
#   DOTFILES_WAITING_ON_DEPS
# Returns:
#   None
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
function __iterate_scripts_waiting_on_deps() {
  local key
  if [[ -n "${ZSH_VERSION}" ]]; then
    for key in "${(k)DOTFILES_WAITING_ON_DEPS[@]}"; do
      printf -- "%s\n" "${key}"
    done
  else
    for key in "${!DOTFILES_WAITING_ON_DEPS[@]}"; do
      printf -- "%s\n" "${key}"
    done
  fi
}
