#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/test/unit_test.sh

test_directory="$BASH_UTILS_HOME/_tests"
if [[ -d "$test_directory" ]]; then rm -r "$test_directory"; mkdir "$test_directory"; else mkdir "$test_directory"; fi

before_all_counter=0
after_all_counter=0
before_each_counter=0
after_each_counter=0

read_counter() {
  cat "$test_directory/$1"
}

unit_test::before_all() {
  before_all_counter=$((before_all_counter + 1))
  echo "$before_all_counter" > "$test_directory/before_all.counter"
}

unit_test::after_all() {
  after_all_counter=$((after_all_counter + 1))
  echo "$after_all_counter" > "$test_directory/after_all.counter"
}

unit_test::before_each() {
  before_each_counter=$((before_each_counter + 1))
  echo "$before_each_counter" > "$test_directory/before_each.counter"
}

unit_test::after_each() {
  after_each_counter=$((after_each_counter + 1))
  echo "$after_each_counter" > "$test_directory/after_each.counter"
}

test::should_be_runned_without_errors() {
  echo "test 1"
}

test::should_be_runned_with_errors() {
  exit 1
}

test::should_also_be_runned_with_errors() {
  exit 1
}

# Command substitution to catch error
$(unit_test::run) || true

[[ "$(read_counter "before_all.counter")" -ne 1 ]] && logger::error "[TEST] before_all test failed !" && exit 1
[[ "$(read_counter "after_all.counter")" -ne 1 ]] && logger::error "[TEST] after_all test failed !" && exit 1
[[ "$(read_counter "before_each.counter")" -ne 3 ]] && logger::error "[TEST] before_each test failed !" && exit 1
[[ "$(read_counter "after_each.counter")" -ne 3 ]] && logger::error "[TEST] after_each test failed !" && exit 1
logger::info "[Test] Success for before and after functions"

rm -r "$test_directory"
