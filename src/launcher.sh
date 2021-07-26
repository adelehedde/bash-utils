#!/bin/bash

# Set debug mode
[[ "$XTRACE" == "true" ]] && set -x

BASH_UTILS_HOME="$(cd "$(dirname "$0")" && pwd)" && export BASH_UTILS_HOME

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/utils/assert.sh
source "$BASH_UTILS_HOME"/utils/runner.sh
[[ "$LANG" != "en_US.utf8" ]] && logger::warn "Locale is not set to UTF-8"

# Get script to run
script="$BASH_UTILS_HOME/$1"
assert::file_exists "$script" "<script> argument expected !"
# Remove it from opts
shift
# shellcheck disable=SC2124
arguments="$@"

# Main
runner::run "$script" "$arguments"

exit 0
