#!/bin/bash

set -euo pipefail

EXPECTED_OUTPUT="33"
ACTUAL_OUTPUT=$(cd examples/c_module && node --preserve-symlinks-main test_c_module.js)

if [[ "$ACTUAL_OUTPUT" != "$EXPECTED_OUTPUT" ]]; then
  echo "ERROR: Expected $EXPECTED_OUTPUT, got $ACTUAL_OUTPUT" 1>&2
  exit 1
fi