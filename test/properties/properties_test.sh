#!/bin/bash

TEST_HOME="$( cd "$( dirname "$0" )" && cd .. && pwd )"

source "$BASH_UTILS_HOME"/test/unit_test.sh
source "$BASH_UTILS_HOME"/test/assert_test.sh
source "$BASH_UTILS_HOME"/properties/properties.sh
source "$BASH_UTILS_HOME"/utils/assert.sh

unit_test::before_each() {
  test_directory="$BASH_UTILS_HOME/_tests"
  test_properties_file_path="$test_directory/test.properties"
  if [[ -d "$test_directory" ]]; then rm -r "$test_directory"; mkdir "$test_directory"; else mkdir "$test_directory"; fi
  cp "$TEST_HOME/properties/data/test.properties" "$test_properties_file_path"
}

unit_test::after_all() {
  rm -r "$test_directory"
}

test::should_get_property() {
  property="$(properties::get "property" "$test_properties_file_path")"
  assert_test::equals "value" "$property"
}

test::should_get_correct_property() {
  property="$(properties::get "property.key.2" "$test_properties_file_path")"
  assert_test::equals "value.2" "$property"
}

test::should_get_property_case_insensitive() {
  property="$(properties::get "upper_property" "$test_properties_file_path" "true")"
  assert_test::equals "VALUE" "$property"
}

test::should_get_empty_value_when_property_does_not_exist() {
  property="$(properties::get "666" "$test_properties_file_path")"
  assert_test::equals "" "$property"
}

test::should_get_required_property() {
  property="$(properties::get_required "property" "$test_properties_file_path")"
  assert_test::equals "value" "$property"
}

test::should_exit_when_property_is_not_present() {
  assert_test::exit "properties::get_required 666 $test_properties_file_path"
}

test::should_update_property() {
  properties::set "property.key.2"  "new value" "$test_properties_file_path"
  assert_test::md5_equals "11ef1938e5db6d288f8f0bfeb5610d7b" "$test_properties_file_path"
}

test::should_add_property() {
  properties::set "property.key.4"  "value4" "$test_properties_file_path"
  assert_test::md5_equals "3e7645ecdd80685db9249bab088f0e3f" "$test_properties_file_path"
}

test::should_update_empty_property() {
  local empty_value=""
  properties::set "property.key.1" "$empty_value" "$test_properties_file_path"
  assert_test::md5_equals "5d29ae94a931d1da91972dc1165cc879" "$test_properties_file_path"
}

test::should_add_empty_property() {
  local empty_value=""
  properties::set "property.key.4" "$empty_value" "$test_properties_file_path"
  assert_test::md5_equals "af8acc944c2d0ff6df174a45214538a0" "$test_properties_file_path"
}

unit_test::run
