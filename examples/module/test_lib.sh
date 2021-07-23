#!/bin/bash

set -euo pipefail
set -x

cat examples/module/calc.js
node examples/module/calc.js

exit 1