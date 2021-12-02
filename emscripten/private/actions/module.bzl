def emit_module(emscripten, name = "", srcs = []):
    output_js = emscripten.actions.declare_file(name + ".js")
    output_wasm = emscripten.actions.declare_file(name + ".wasm")

    inputs = srcs + [emscripten.sdk.emcc_py]
    args = emscripten.actions.args()
    args.add("-o", output_js)
    args.add("-s", "MODULARIZE=1")
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

    return output_js, output_wasm