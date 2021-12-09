def emit_binary(emscripten, name = "", srcs = []):
    compile_results = emscripten.compile(
        emscripten,
        srcs = srcs
    )

    link_results = emscripten.link(
        emscripten,
        name = name,
        objs = compile_results.objs,
        emit_wasm = True,
    )

    output_arr = [link_results.output_js]
    if link_results.output_wasm:
        output_arr.append(link_results.output_wasm)

    executable = emscripten.actions.declare_file("{}_/binary.sh".format(name))
    emscripten.actions.write(
        output = executable,
        content = """#!/bin/bash

set -euo pipefail

exec node {js_file}""".format(js_file = link_results.output_js.short_path),
        is_executable = True,
    )

    runfiles = emscripten.runfiles(output_arr)

    return struct(
        files = depset(output_arr),
        output_js = link_results.output_js,
        output_wasm = link_results.output_wasm,
        executable = executable,
        runfiles = runfiles,
    )
