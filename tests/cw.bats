#!/usr/bin/env bats
# cw CLI tests using BATS (Bash Automated Testing System)
# Run: bats tests/cw.bats
# Install bats: brew install bats-core

setup() {
  # Get the directory of the test file
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" && pwd )"
  CW="$DIR/../bin/cw"

  # Create temp directory for test repos
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"

  # Initialize a test git repo
  git init -q test-repo
  cd test-repo
  git config user.email "test@test.com"
  git config user.name "Test User"
  echo "test" > README.md
  git add .
  git commit -q -m "Initial commit"
}

teardown() {
  # Clean up test directory
  rm -rf "$TEST_DIR"
}

@test "cw --version shows version" {
  run "$CW" --version
  [ "$status" -eq 0 ]
  [[ "$output" =~ "cw version" ]]
}

@test "cw -v shows version" {
  run "$CW" -v
  [ "$status" -eq 0 ]
  [[ "$output" =~ "cw version" ]]
}

@test "cw help shows usage" {
  run "$CW" help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Claude Worktree" ]]
  [[ "$output" =~ "USAGE:" ]]
}

@test "cw with no args shows help" {
  run "$CW"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "USAGE:" ]]
}

@test "cw ls works in git repo" {
  run "$CW" ls
  [ "$status" -eq 0 ]
}

@test "cw ls fails outside git repo" {
  cd /tmp
  run "$CW" ls
  [ "$status" -ne 0 ]
}

@test "cw init creates .worktreerc" {
  run "$CW" init
  [ "$status" -eq 0 ]
  [ -f ".worktreerc" ]
}

@test "cw init includes BASE_PORT" {
  "$CW" init
  run grep "BASE_PORT" .worktreerc
  [ "$status" -eq 0 ]
}

@test "cw init includes BASE_BRANCH" {
  "$CW" init
  run grep "BASE_BRANCH" .worktreerc
  [ "$status" -eq 0 ]
}

@test "cw init detects main branch" {
  "$CW" init
  run grep "BASE_BRANCH=main" .worktreerc
  [ "$status" -eq 0 ]
}

@test "cw new requires branch name" {
  run "$CW" new
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Usage:" ]] || [[ "$output" =~ "branch" ]]
}

@test "cw rm requires branch name" {
  run "$CW" rm
  [ "$status" -ne 0 ]
}

@test "cw go requires branch name" {
  run "$CW" go
  [ "$status" -ne 0 ]
}

@test "cw ports works" {
  run "$CW" ports
  # Should work even with no ports assigned
  [ "$status" -eq 0 ]
}

@test "cw status shows dashboard" {
  run "$CW" status
  [ "$status" -eq 0 ]
  [[ "$output" =~ "WORKTREES" ]] || [[ "$output" =~ "Worktree" ]]
}

@test "cw prune works with no stale worktrees" {
  run "$CW" prune
  [ "$status" -eq 0 ]
}

@test "cw new creates worktree" {
  # Skip auto-claude and terminal opening for test
  run "$CW" new test/feature --no-claude --no-install 2>&1
  [ "$status" -eq 0 ]

  # Check worktree was created
  [ -d "../test-repo__wt/test-feature" ]
}

@test "cw ls shows created worktree" {
  "$CW" new test/feature --no-claude --no-install 2>&1

  run "$CW" ls
  [ "$status" -eq 0 ]
  [[ "$output" =~ "test/feature" ]] || [[ "$output" =~ "test-feature" ]]
}

@test "cw rm removes worktree" {
  "$CW" new test/feature --no-claude --no-install 2>&1

  run "$CW" rm test/feature
  [ "$status" -eq 0 ]

  # Worktree directory should be gone
  [ ! -d "../test-repo__wt/test-feature" ]
}

@test "cw new --from creates from specific branch" {
  # Create a feature branch first
  git checkout -b develop
  echo "develop" > develop.txt
  git add . && git commit -q -m "develop branch"
  git checkout main

  run "$CW" new test/from-develop --from develop --no-claude --no-install 2>&1
  [ "$status" -eq 0 ]

  # Check the worktree has the develop file
  [ -f "../test-repo__wt/test-from-develop/develop.txt" ]
}

@test "cw handles branch names with slashes" {
  run "$CW" new feat/auth/oauth --no-claude --no-install 2>&1
  [ "$status" -eq 0 ]

  # Directory should use dashes
  [ -d "../test-repo__wt/feat-auth-oauth" ]
}
