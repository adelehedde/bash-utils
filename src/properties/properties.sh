#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/utils/assert.sh

# Arguments : [<property_key> <file_path> <optional_case_insensitive>]
properties::get() {
  assert::not_empty "$1" "<property_key> cannot be empty !"
  assert::file_exists "$2" "<file_path> must exist !"
  local escaped_property property_pattern
  local grep_options=""
  escaped_property=$(echo -n "$1" | sed "s#\.#\\\.#g") || exit 1
  property_pattern="^$escaped_property="
  logger::debug "Looking property $1 into $2"
  [[ "${3-false}" == "true" ]] && grep_options="-i"
  grep -E $grep_options "$property_pattern" "$2" | sed 's/.*=//' || echo -n ""
}

# Arguments : [<property_key> <file_path> <optional_case_insensitive>]
properties::get_required() {
  local property
  # shellcheck disable=SC2124
  property=$(properties::get "$@") || exit 1
  [[ -z "$property" ]] && logger::error "Property empty for $1 !" && exit 1
  echo -n "$property"
}

# Arguments : [<property_key> <property_value> <file_path>]
properties::set() {
  assert::not_empty "$1" "<property_key> cannot be empty !"
  assert::file_exists "$3" "<file_path> must exist"
  local property escaped_property
  escaped_property=$(echo -n "$1" | sed "s#\.#\\\.#g") || exit 1
  property=$(grep -E "^$escaped_property=.*" "$3") || echo -n ""
  if [[ -z "$property" ]]; then
    logger::debug "Creating property '$1' in $3"
    echo "$1=$2" >> "$3"
  else
    logger::debug "Updating property '$1' in $3"
    sed -i "s|^$escaped_property=.*|$1=$2|g" "$3"
  fi
}
