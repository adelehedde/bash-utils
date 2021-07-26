#!/bin/bash

source "$BASH_UTILS_HOME"/test/unit_test.sh
source "$BASH_UTILS_HOME"/test/assert_test.sh

source "$BASH_UTILS_HOME"/utils/assert.sh

unit_test::before_all() {
  test_directory="$BASH_UTILS_HOME/_tests"
  if [[ -d "$test_directory" ]]; then rm -r "$test_directory"; mkdir "$test_directory"; else mkdir "$test_directory"; fi
}

unit_test::after_all() {
  rm -r "$test_directory"
}

test::should_assert_not_empty() {
  assert::not_empty "argument" "<argument> cannot be empty" && \
  assert::not_empty "argument"
}

test::should_exit_when_argument_is_empty() {
  local empty_var=""
  assert_test::exit "assert::not_empty" && \
  assert_test::exit "assert::not_empty $empty_var" && \
  assert_test::exit "assert::not_empty $empty_var $empty_var"
}

test::should_assert_file_exists() {
  touch "$test_directory/file.csv"

  assert::file_exists "$test_directory/file.csv" "<file> must exists" && \
  assert::file_exists "$test_directory/file.csv"
}

test::should_exit_when_argument_is_empty_or_file_does_not_exist() {
  local empty_var=""
  assert_test::exit "assert::file_exists" && \
  assert_test::exit "assert::file_exists $empty_var" && \
  assert_test::exit "assert::file_exists $empty_var $empty_var" && \
  assert_test::exit "assert::file_exists /test.csv"
}

test::should_assert_directory_exists() {
  mkdir "$test_directory/folder_test"

  assert::directory_exists "$test_directory/folder_test" "<directory> must exists" && \
  assert::directory_exists "$test_directory/folder_test"
}

test::should_exit_when_argument_is_empty_or_directory_does_not_exist() {
  local empty_var=""
  assert_test::exit "assert::directory_exists" && \
  assert_test::exit "assert::directory_exists $empty_var" && \
  assert_test::exit "assert::directory_exists $empty_var $empty_var" && \
  assert_test::exit "assert::directory_exists /test_folder"
}

unit_test::run
