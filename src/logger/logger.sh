#!/bin/bash

# Open a new file descriptor that redirects to stdout
exec 3>&1

LOGGER_SEPARATOR="|"

# ISO8601 UTC timestamp
logger::get_current_date() {
  date --utc +%FT%T.%3NZ
}

logger::log() {
  echo "$(logger::get_current_date)$LOGGER_SEPARATOR$1$LOGGER_SEPARATOR${FUNCNAME[2]}$LOGGER_SEPARATOR$2" 1>&3
}

logger::fatal() {
  logger::log "FATAL" "$1"
}

logger::error() {
  logger::log "ERROR" "$1"
}

logger::warn() {
  logger::log "WARN" "$1"
}

logger::info() {
  logger::log "INFO" "$1"
}

logger::debug() {
  logger::log "DEBUG" "$1"
}

logger::verbose() {
  logger::log "VERBOSE" "$1"
}
