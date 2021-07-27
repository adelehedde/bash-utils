#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/utils/assert.sh

date::current_time() {
  echo -n "$(date +%s)"
}

date::current_time_milliseconds() {
  echo -n "$(date +%s%3N)"
}

date::current_time_nanoseconds() {
  echo -n "$(date +%s%N)"
}

date::iso_8601() {
  echo -n "$(date --utc +%FT%TZ)"
}

date::iso_8601_milliseconds() {
  echo -n "$(date --utc +%FT%T.%3NZ)"
}

# Arguments : [<iso_date>]
date::iso_to_timestamp() {
  assert::not_empty "$1" "<iso_date> cannot be empty !"
  local timestamp
  timestamp=$(date -d"$1" +%s) || {
    logger::error "Unable to convert following date : $1"
    exit 1
  }
  echo -n "$timestamp"
}

# Arguments : [<iso_date1> <iso_date2>]
date::date_diff() {
  assert::not_empty "$1" "<iso_date1> cannot be empty !"
  assert::not_empty "$2" "<iso_date2> cannot be empty !"
  local timestamp1 timestamp2
  timestamp1=$(date::iso_to_timestamp "$1") || exit 1
  timestamp2=$(date::iso_to_timestamp "$2") || exit 1
  echo -n $((timestamp1 - timestamp2))
}

