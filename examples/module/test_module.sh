#!/bin/bash

set -euo pipefail

find .

cd examples/module
node test_module.js