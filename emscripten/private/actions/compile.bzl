def compile(emscripten, srcs):
    objs = []
    for src in srcs:
        if src.basename.endswith(".hpp"):
            continue
        obj = emscripten.actions.declare_file(src.basename + ".o")

        args = emscripten.actions.args()
        args.add("compile")
        args.add("-o", obj)
        args.add("-e", emscripten.sdk.emcc)
        args.add("-c", emscripten.sdk.emconfig)
        args.add(src)
        emscripten.actions.run(
            inputs = [src, emscripten.sdk.emconfig] + emscripten.sdk.emsdk,
            outputs = [obj],
            executable = emscripten.toolchain._builder,
            arguments = [args],
            tools = [emscripten.sdk.emcc],
            mnemonic = "EmccCompile",
            # no-sandbox because emcc will write to the repository's cache directory
            execution_requirements = {
                "no-sandbox": "1",
            }
        )
        objs.append(obj)

    return struct(
        objs = objs,
    )
