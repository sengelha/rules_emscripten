def emit_binary(emscripten, name = "", srcs = []):
    output_js = emscripten.actions.declare_file(name + ".js")
    output_wasm = emscripten.actions.declare_file(name + ".wasm")

    inputs = srcs + emscripten.sdk.emsdk + [emscripten.sdk.emcc_py]
    args = emscripten.actions.args()
    args.add("-o", output_js)
    args.add_all(srcs)
    emscripten.actions.run(
        inputs = inputs,
        outputs = [output_js, output_wasm],
        executable = emscripten.sdk.emcc,
        arguments = [args],
        mnemonic = "EmccCompile",
        env = {
            "EM_CACHE": emscripten.sdk.cache.path,
        },
    )

    executable = emscripten.actions.declare_file(name + "_/binary.sh")
    emscripten.actions.write(
        output = executable,
        content = """#!/bin/bash

set -euo pipefail

exec node {js_file}""".format(js_file = output_js.short_path),
        is_executable = True,
    )
    runfiles = emscripten.runfiles([output_js, output_wasm])

    return output_js, output_wasm, executable, runfiles