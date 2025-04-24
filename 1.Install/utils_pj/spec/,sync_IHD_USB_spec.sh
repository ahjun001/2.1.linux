#!/usr/bin/env bash
# ,sync_IHD_USB_spec.sh
# DOES NOT WORK
set -euo pipefail

eval "$(shellspec - -E 'Basic*' ) exit 1"

Describe "Basic functionality tests"
  It "shows the usage"
    When call Usage
    The output should include 'mimi / safe / home'
    The error should eq ''
    The status should be success
  End

  It "fails when no arguments provided"
    When call Setup
    The status should be failure
    The output should include 'Usage'
  End

  It "fails with invalid argument"
    When call Setup invalid_arg
    The status should be failure
    The output should include 'Usage'
  End
End

Describe "Setup function tests"
  # Mock directories for testing
  setup() {
    export TEST_DIR
    TEST_DIR=$(mktemp -d)
    mkdir -p "$TEST_DIR/Documents/IHD_mimi"
    mkdir -p "$TEST_DIR/run/media/$USER/USB_mimi"
    HOME="$TEST_DIR"
  }
  cleanup() {
    rm -rf "$TEST_DIR"
  }
  BeforeEach setup
  AfterEach cleanup

  It "sets up mimi correctly"
    When call Setup mimi
    The variable HD should eq "$TEST_DIR/Documents/IHD_mimi"
    The variable UD should eq "$TEST_DIR/run/media/$USER/USB_mimi"
    The status should be success
  End

  It "fails when mimi directory doesn't exist"
    rm -rf "$TEST_DIR/Documents/IHD_mimi"
    When call Setup mimi
    The status should be failure
    The output should include 'cannot be reached'
  End

  It "fails when USB directory doesn't exist"
    rm -rf "$TEST_DIR/run/media/$USER/USB_mimi"
    When call Setup mimi
    The status should be failure
    The output should include 'cannot be reached'
  End
End

Describe "Home directory special case"
  setup_home() {
    export TEST_DIR
    TEST_DIR=$(mktemp -d)
    # Create all required home folders
    for f in Desktop Documents Downloads Music Pictures Videos Public Templates; do
      mkdir -p "$TEST_DIR/$f"
    done
    mkdir -p "$TEST_DIR/run/media/$USER/USB_home"
    HOME="$TEST_DIR"
  }
  BeforeEach setup_home
  AfterEach cleanup

  It "sets up home correctly and creates USB folders"
    When call Setup home
    The variable HD should eq "$TEST_DIR"
    The variable UD should eq "$TEST_DIR/run/media/$USER/USB_home"
    The status should be success
    
    # Verify USB folders were created
    for f in Desktop Documents Downloads Music Pictures Videos Public Templates; do
      The directory "$TEST_DIR/run/media/$USER/USB_home/$f" should be exist
    done
  End

  It "fails when home folders are missing"
    rm -rf "$TEST_DIR/Documents"
    When call Setup home
    The status should be failure
    The output should include 'cannot be reached'
  End
End

: "
Adding tests for Diff, Meld, and Rsync functions (though these would require more complex mocking)

Testing the symlink creation at the end of the script

Adding integration tests that actually perform operations on test directories

Testing the interactive parts of Rsync function
"
