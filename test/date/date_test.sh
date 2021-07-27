#!/bin/bash

source "$BASH_UTILS_HOME"/test/unit_test.sh
source "$BASH_UTILS_HOME"/test/assert_test.sh

source "$BASH_UTILS_HOME"/date/date.sh

test::should_print_dates() {
  date::current_time && \
  date::current_time_milliseconds && \
  date::current_time_nanoseconds && \
  date::iso_8601 && \
  date::iso_8601_milliseconds
}

test::should_convert_iso_date_to_timestamp() {
  local timestamp1 timestamp2 timestamp3
  timestamp1=$(date::iso_to_timestamp "1970-01-01T00:00:00Z")
  timestamp2=$(date::iso_to_timestamp "Thu Jan 01 1970 UTC")
  timestamp3=$(date::iso_to_timestamp "2021-07-27T14:49:45Z")
  assert_test::equals "0" "$timestamp1"
  assert_test::equals "0" "$timestamp2"
  assert_test::equals "1627397385" "$timestamp3"
}

test::should_exit_when_conversion_fails_due_to_bad_format() {
  assert_test::exit "date::iso_to_timestamp 27072021"
}

test::should_print_date_diff() {
  local diff1 diff2 diff3
  local date1="2021-07-27T14:49:45Z"
  local date2="2021-07-27T14:56:31Z"
  diff1=$(date::date_diff "$date1" "$date2")
  diff2=$(date::date_diff "$date2" "$date1")
  diff3=$(date::date_diff "$date1" "$date1")
  assert_test::equals "-406" "$diff1"
  assert_test::equals "406" "$diff2"
  assert_test::equals "0" "$diff3"
}

test::should_exit_when_date_diff_fails_due_to_bad_format() {
  assert_test::exit "date::date_diff 2021-07-27T14:49:45Z 27072021" && \
  assert_test::exit "date::date_diff 27072021 2021-07-27T14:49:45Z"
}

unit_test::run