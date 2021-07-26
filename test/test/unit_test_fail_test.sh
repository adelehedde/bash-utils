#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/test/unit_test.sh

test_directory="$BASH_UTILS_HOME/_tests"
if [[ -d "$test_directory" ]]; then rm -r "$test_directory"; mkdir "$test_directory"; else mkdir "$test_directory"; fi

success_counter=0

success_function() {
  success_counter=$((success_counter + 1))
  echo "$success_counter" > "$test_directory/success.counter"
}

exit_function() {
  exit 1
}

test::should_be_runned_with_errors() {
  echo "test" && \
  exit 1 && \
  success_function
}

test::should_be_runned_with_errors_when_function_exits() {
  echo "test" && \
  exit_function && \
  success_function
}

test::should_also_be_runned_with_errors_when_function_exits() {
  echo "test"
  exit_function
  success_function
}

test::should_be_runned_with_errors_when_function_exits_in_command_substitution() {
  echo "test" && \
  $(exit_function) && \
  success_function
}

test::should_also_be_runned_with_errors_when_function_exits_in_command_substitution() {
  echo "test"
  $(exit_function) || exit 1
  success_function
}

# Command substitution to catch error
$(unit_test::run) || true

[[ -f "$test_directory/success.counter" ]] && logger::error "[TEST] success_counter should not exist !" && exit 1

rm -r "$test_directory"
