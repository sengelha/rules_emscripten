#!/bin/bash

set -euo pipefail

BINARY_EXE=$1
if [[ ! -x $BINARY_EXE ]]; then
  echo "ERROR: $BINARY_EXE is not executable" 1>&2
  exit 1
fi

EXPECTED_OUTPUT="Hello world!"
ACTUAL_OUTPUT=$($BINARY_EXE)

if [[ "$ACTUAL_OUTPUT" != "$EXPECTED_OUTPUT" ]]; then
  echo "ERROR: Expected $EXPECTED_OUTPUT, got $ACTUAL_OUTPUT" 1>&2
  exit 1
fi