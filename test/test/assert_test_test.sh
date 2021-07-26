#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/test/unit_test.sh
source "$BASH_UTILS_HOME"/test/assert_test.sh

unit_test::before_all() {
  test_directory="$BASH_UTILS_HOME/_tests"
  if [[ -d "$test_directory" ]]; then rm -r "$test_directory"; mkdir "$test_directory"; else mkdir "$test_directory"; fi
}

unit_test::after_all() {
  rm -r "$test_directory"
}

test::should_assert_equals() {
  assert_test::equals "value1" "value1" && \
  assert_test::equals 1 1 && \
  assert_test::equals "" ""
}

test::should_assert_file_equals() {
  echo "file content" > "$test_directory/file1.csv"
  echo "file content" > "$test_directory/file2.csv"

  assert_test::file_equals "$test_directory/file1.csv" "$test_directory/file2.csv"
}

test::should_assert_md5_equals() {
  echo "file content" > "$test_directory/file1.csv"

  assert_test::md5_equals "186e4cee4e00635b35be4236193f33fb" "$test_directory/file1.csv"
}

test::should_assert_cmd_exit() {
  assert_test::exit "exit 1"
}

unit_test::run