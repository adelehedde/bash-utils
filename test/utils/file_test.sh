#!/bin/bash

source "$BASH_UTILS_HOME"/test/unit_test.sh
source "$BASH_UTILS_HOME"/test/assert_test.sh

source "$BASH_UTILS_HOME"/utils/file.sh

unit_test::before_all() {
  test_directory="$BASH_UTILS_HOME/_tests"
  if [[ -d "$test_directory" ]]; then rm -r "$test_directory"; mkdir "$test_directory"; else mkdir "$test_directory"; fi
  mkdir "$test_directory/empty"
  mkdir "$test_directory/not_empty_1"
  mkdir "$test_directory/not_empty_2"
  mkdir "$test_directory/not_empty_3"
  touch "$test_directory/not_empty_1/file.csv"
  touch "$test_directory/not_empty_2/.file.csv"
  mkdir "$test_directory/not_empty_3/folder"
}

unit_test::after_all() {
  rm -r "$test_directory"
}

test::should_assert_directory_is_empty() {
  is_empty=$(file::is_empty_directory "$test_directory/empty")
  assert_test::equals "true" "$is_empty"
}

test::should_assert_directory_is_not_empty() {
  is_empty_1=$(file::is_empty_directory "$test_directory/not_empty_1")
  is_empty_2=$(file::is_empty_directory "$test_directory/not_empty_2")
  is_empty_3=$(file::is_empty_directory "$test_directory/not_empty_3")
  assert_test::equals "false" "$is_empty_1"
  assert_test::equals "false" "$is_empty_2"
  assert_test::equals "false" "$is_empty_3"
}

test::should_exit_when_directory_does_not_exist() {
  assert_test::exit "file::is_empty_directory $test_directory/666"
}

unit_test::run