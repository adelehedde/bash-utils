#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh
source "$BASH_UTILS_HOME"/test/unit_test.sh

should_not_be_executed() {
  echo "private function"
  exit 1
}

test::should_be_runned_without_errors() {
  echo "test 1" && \
  echo "test 2"
}

unit_test::run
