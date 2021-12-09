#!/bin/bash

set -euo pipefail

EXPECTED_OUTPUT="abs(-1)=1
1+2=3
3-1=2"
ACTUAL_OUTPUT=$(cd examples/embind && node --preserve-symlinks-main test_module.js)

if [[ "$ACTUAL_OUTPUT" != "$EXPECTED_OUTPUT" ]]; then
  echo "ERROR: Expected $EXPECTED_OUTPUT, got $ACTUAL_OUTPUT" 1>&2
  exit 1
fi