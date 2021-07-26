#!/bin/bash

source "$BASH_UTILS_HOME"/logger/logger.sh

# Arguments : [<function_name>]
unit_test::function_exists() {
  declare -F "$1" > /dev/null
  local declare_result=$?
  if [[ "$declare_result" == 0 ]]; then
    echo "true"
  else
    echo "false"
  fi
}

unit_test::run() {
  local script_name="${0##*/}"
  logger::info "[TEST] Running script : $script_name"
  local nb_executed_tests=0
  local nb_errors=0
  local before_all_exists after_all_exists before_each_exists after_each_exists
  before_all_exists=$(unit_test::function_exists "unit_test::before_all")
  after_all_exists=$(unit_test::function_exists "unit_test::after_all")
  before_each_exists=$(unit_test::function_exists "unit_test::before_each")
  after_each_exists=$(unit_test::function_exists "unit_test::after_each")

  [[ "$before_all_exists" == "true" ]] && unit_test::before_all

  # For Each test::* function
  for f in $(declare -F | awk '{print $NF}' | sort | grep -Ev "^_" | grep -E "^test::.+"); do
    logger::info "[TEST] Running test '$f'"
    nb_executed_tests=$((nb_executed_tests + 1))

    [[ "$before_each_exists" == "true" ]] && unit_test::before_each

    local function_result
    # shellcheck disable=SC2034
    function_result=$("$f")
    local function_status=$?
    if [[ "$function_status" != 0 ]]; then
      logger::error "[TEST] Following test has failed : $f"
      nb_errors=$((nb_errors + 1))
    else
      logger::info "[TEST] Success for test '$f' !"
    fi

    [[ "$after_each_exists" == "true" ]] && unit_test::after_each
  done

  [[ "$after_all_exists" == "true" ]] && unit_test::after_all

  logger::info "[TEST] Nb executed tests : $nb_executed_tests"
  if [[ "$nb_errors" -gt 0 ]]; then
    logger::error "[TEST] $nb_errors failed tests !"
    exit 1
  else
    logger::info "[TEST] Tests from $script_name are successful !"
  fi
}
