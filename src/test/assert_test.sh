#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/utils/assert.sh

# Arguments : [<expected> <actual>]
assert_test::equals() {
  if [[ "$1" != "$2" ]]; then
    logger::error "[TEST] assert_test::equals - Expected : '$1', Actual : '$2'"
    exit 1
  fi
}

# Arguments : [<expected_file_path> <actual_file_path>]
assert_test::file_equals() {
  assert::file_exists "$1" "<expected_file_path> does not exist !"
  assert::file_exists "$2" "<actual_file_path> does not exist !"
  local expected_md5sum actual_md5sum
  expected_md5sum=$(md5sum "$1" | cut -d" " -f1)
  actual_md5sum=$(md5sum "$2" | cut -d" " -f1)
  if [[ "$expected_md5sum" != "$actual_md5sum" ]]; then
    logger::error "[TEST] assert_test::file_equals - Expected md5sum : '$expected_md5sum', Actual md5sum : '$actual_md5sum'"
    exit 1
  fi
}

# Arguments : [<expected_md5> <file_path>]
assert_test::md5_equals() {
  assert::not_empty "$1" "<expected_md5> argument cannot be empty !"
  assert::file_exists "$2" "<file_path> must exist !"
  logger actual_md5sum
  actual_md5sum=$(md5sum "$2" | cut -d" " -f1)
  if [[ "$1" != "$actual_md5sum" ]]; then
    logger::error "[TEST] assert_test::md5_equals - Expected md5sum : '$1', Actual md5sum : '$actual_md5sum'"
    exit 1
  fi
}

# Arguments : [<command>]
assert_test::exit() {
  assert::not_empty "$1" "<command> argument cannot be empty !"
  local command_result command_status
  # shellcheck disable=SC2034
  command_result=$($1)
  command_status=$?
  if [[ "$command_status" == 0 ]]; then
    logger::error "[Test] Expected following command to exit : '$1'"
    exit 1
  fi
}

