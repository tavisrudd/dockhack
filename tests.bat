#!/usr/bin/env bats
## tests with https://github.com/sstephenson/bats

die() {
    echo "$@" >/dev/stderr
    exit 1
}

export DOCKHACK_SKIP_UID_CHECK=1

################################################################################
## mocked docker command
#which docker &>/dev/null || die "ERROR: docker must be installed to run tests"
source $BATS_TEST_DIRNAME/mock_docker # for test fixture variables
export mock_docker="$BATS_TEST_DIRNAME/mock_docker"
docker() {
    "$mock_docker" "$@"
}
export -f docker
################################################################################


@test "running with no args prints usage & exit code 2." {
  run ./dockhack
  [ "$status" -eq 2 ]
  # can't distinguish between stdout/err yet https://github.com/sstephenson/bats/pull/55
  [[ "$output" =~ "Usage" ]]
}

@test "-h/--help print usage & exit code 0." {
  run ./dockhack -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage" ]]
  run ./dockhack --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage" ]]
}

@test "'dockhack lib' is a no-op" {
  run ./dockhack lib
  [ "$status" -eq 0 ]
  [[ "$output" = "" ]]
}

@test "'get_id last' == 'get_id l' == 'id last'" {
  local -a commands=('get_id last' 'get_id l' 'id last')
  for com in "${commands[@]}"; do
      eval "run ./dockhack $com"
      echo ">> $com : $output"
      [[ "$status" -eq 0 ]]
      [[ "$output" = "$TEST_ID" ]] || die "bad out"
  done
}

@test "'get_id $TEST_NAME' == 'id $TEST_NAME'" {
  local -a commands=("get_id $TEST_NAME" "id $TEST_NAME")
  for com in "${commands[@]}"; do
      eval "run ./dockhack $com"
      [[ "$status" -eq 0 ]]
      [[ "$output" = "$TEST_ID" ]] || die "bad out"
  done
}

@test "dummy test" {
    true
}
