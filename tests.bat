#!/usr/bin/env bats
## tests with https://github.com/sstephenson/bats

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
