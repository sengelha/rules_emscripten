#!/bin/bash

set -euo pipefail

EXPECTED_OUTPUT="Hello world!"
ACTUAL_OUTPUT=$(node examples/binary/binary.js)

if [[ "$ACTUAL_OUTPUT" != "$EXPECTED_OUTPUT" ]]; then
  echo "ERROR: Expected $EXPECTED_OUTPUT, got $ACTUAL_OUTPUT" 1>&2
  exit 1
fi