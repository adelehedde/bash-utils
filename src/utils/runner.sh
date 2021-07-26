#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/utils/assert.sh

# Arguments : [<script> <arguments>]
runner::run() {
  assert::not_empty "$1" "<script> cannot be empty !"
  assert::file_exists "$1" "<script> must exists !"
  local script="$1"
  shift
  # Set runner
  local runner="bash"
  local command command_status
  [[ "$XTRACE" == "true" ]] && runner="bash -x"
  # shellcheck disable=SC2124
  command="$runner $script $@"
  logger::info "Running $command"
  $command
  command_status=$?
  if [[ "$command_status" != 0 ]]; then
    logger::info "Error while running command $command !"
    exit 1
  fi
}
