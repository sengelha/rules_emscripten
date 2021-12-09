def link(emscripten, name, objs, linkopts = [], modularize = False):
    output_js = emscripten.actions.declare_file(name + ".js")
    output_wasm = emscripten.actions.declare_file(name + ".wasm")

    args = emscripten.actions.args()
    args.add("link")
    args.add("-o", output_js)
    args.add("-e", emscripten.sdk.emcc)
    args.add("-c", emscripten.sdk.emconfig)
    args.add_joined("-l", linkopts, join_with = ";")
    if modularize:
        args.add("-m")
    args.add_all(objs)
    emscripten.actions.run(
        inputs = objs + [emscripten.sdk.emconfig] + emscripten.sdk.emsdk,
        outputs = [output_js, output_wasm],
        executable = emscripten.toolchain._builder,
        arguments = [args],
        tools = [emscripten.sdk.emcc],
        mnemonic = "EmccLink",
        # no-sandbox because emcc will write to the repository's cache directory
        execution_requirements = {
            "no-sandbox": "1",
        },
    )

    return output_js, output_wasm
