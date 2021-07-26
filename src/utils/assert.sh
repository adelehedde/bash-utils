#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh

# Arguments : [<variable> <message>]
assert::not_empty() {
  local message="$2"
  [[ -z "$2" ]] && logger::warn "assert::not_empty : No message provided" && message="Argument cannot be empty !"
  [[ -z "$1" ]] && logger::error "$message" && exit 1
  logger::debug "Assertion is valid"
}

# Arguments : [<file_path> <message>]
assert::file_exists() {
  local message="$2"
  [[ -z "$2" ]] && logger::warn "assert::file_exists : No message provided" && message="File must exist !"
  [[ -z "$1" ]] && logger::error "<file_path> argument is empty : $message" && exit 1
  [[ ! -f "$1" ]] && logger::error "File $1 does not exist : $message" && exit 1
  logger::debug "Assertion is valid"
}

# Arguments : [<directory_path> <message>]
assert::directory_exists() {
  local message="$2"
  [[ -z "$2" ]] && logger::warn "assert::directory_exists : No message provided" && message="Directory must exist !"
  [[ -z "$1" ]] && logger::error "<directory_path> argument is empty : $message" && exit 1
  [[ ! -d "$1" ]] && logger::error "Directory $1 does not exist : $message" && exit 1
  logger::debug "Assertion is valid"
}
