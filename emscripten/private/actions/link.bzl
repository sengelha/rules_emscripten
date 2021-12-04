def link(emscripten, name, objs, modularize=False):
    output_js = emscripten.actions.declare_file(name + ".js")
    output_wasm = emscripten.actions.declare_file(name + ".wasm")

    args = emscripten.actions.args()
    args.add("-o", output_js)
    args.add_all(objs)
    if modularize:
        args.add("-s", "MODULARIZE=1")
    emscripten.actions.run(
        inputs = objs + [emscripten.sdk.emcc_py],
        outputs = [output_js, output_wasm],
        executable = emscripten.sdk.emcc,
        arguments = [args],
        mnemonic = "EmccLink",
        env = {
            "EM_CACHE": emscripten.sdk.cache.path,
        },
    )

    return output_js, output_wasm