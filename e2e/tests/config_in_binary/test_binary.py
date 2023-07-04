#!/usr/bin/python -tt

import os
import subprocess
import sys

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)
  
launcher = sys.argv[1]
if not os.path.isfile(launcher):
    eprint("{} is not a file".format(launcher))
    sys.exit(1)
launcher_abs = os.path.realpath(launcher)

r = subprocess.run([launcher_abs], stdout=subprocess.PIPE, text=True)
if r.returncode != 0:
    eprint("{} exited with non-zero exit code {}".format(launcher, r.returncode))
    sys.exit(r.returncode)

actual = r.stdout.rstrip()
expected = "Hello world!"
if actual != expected:
    eprint("Expected \"{}\", actual \"{}\"".format(expected, actual))
    sys.exit(1)