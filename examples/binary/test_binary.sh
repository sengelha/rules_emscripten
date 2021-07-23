#!/bin/bash

set -euo pipefail

EMCC_BINARY=$1

EXPECTED_OUTPUT="Hello world!"
ACTUAL_OUTPUT=$($EMCC_BINARY)

if [[ "$ACTUAL_OUTPUT" != "$EXPECTED_OUTPUT" ]]; then
  echo "ERROR: Expected $EXPECTED_OUTPUT, got $ACTUAL_OUTPUT" 1>&2
  exit 1
fi