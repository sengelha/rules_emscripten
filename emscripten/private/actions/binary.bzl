def emit_binary(emscripten, name = "", srcs = []):
    objs = emscripten.compile(
        emscripten,
        srcs = srcs
    )

    js, wasm = emscripten.link(
        emscripten,
        name = name,
        objs = objs,
    )

    executable = emscripten.actions.declare_file("{}_/binary.sh".format(name))
    emscripten.actions.write(
        output = executable,
        content = """#!/bin/bash

set -euo pipefail

exec node {js_file}""".format(js_file = js.short_path),
        is_executable = True,
    )
    runfiles = emscripten.runfiles([js, wasm])

    return js, wasm, executable, runfiles
