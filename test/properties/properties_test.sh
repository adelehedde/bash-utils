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
  local property
  property="$(properties::get "property" "$test_properties_file_path")"
  assert_test::equals "value" "$property"
}

test::should_get_correct_property() {
  local property
  property="$(properties::get "property.key.2" "$test_properties_file_path")"
  assert_test::equals "value.2" "$property"
}

test::should_get_property_case_insensitive() {
  local property
  property="$(properties::get "upper_property" "$test_properties_file_path" "true")"
  assert_test::equals "VALUE" "$property"
}

test::should_get_empty_value_when_property_does_not_exist() {
  local property
  property="$(properties::get "666" "$test_properties_file_path")"
  assert_test::equals "" "$property"
}

test::should_get_required_property() {
  local property
  property="$(properties::get_required "property" "$test_properties_file_path")"
  assert_test::equals "value" "$property"
}

test::should_exit_when_property_is_not_present() {
  assert_test::exit "properties::get_required 666 $test_properties_file_path"
}

test::should_update_property() {
  properties::set "property.key.2"  "new value" "$test_properties_file_path"
  assert_test::md5_equals "f643f910aeb4737868c4fdc2ab60b90f" "$test_properties_file_path"
}

test::should_add_property() {
  properties::set "property.key.4"  "value4" "$test_properties_file_path"
  assert_test::md5_equals "6ebc0255015f4c6c4f68a464de8470d5" "$test_properties_file_path"
}

test::should_update_empty_property() {
  local empty_value=""
  properties::set "property.key.1" "$empty_value" "$test_properties_file_path"
  assert_test::md5_equals "c0cf1c21da158137c4e0547915f83ec6" "$test_properties_file_path"
}

test::should_add_empty_property() {
  local empty_value=""
  properties::set "property.key.4" "$empty_value" "$test_properties_file_path"
  assert_test::md5_equals "d633d33fc3e9da363f74a4778fb5b68b" "$test_properties_file_path"
}

unit_test::run
