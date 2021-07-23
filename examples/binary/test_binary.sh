#!/bin/bash

set -euo pipefail
set -x

find .

cat examples/binary/binary.js
node examples/binary/binary.js
