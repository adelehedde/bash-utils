#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/utils/assert.sh

# Arguments : [<directory_path>]
file::is_empty_directory() {
  assert::directory_exists "$1" "<directory_path> must exist !"
  if [[ -z "$(ls -A "$1")" ]]; then
    echo -n "true"
  else
    echo -n "false"
  fi
}
