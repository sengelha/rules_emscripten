def compile(emscripten, srcs):
    objs = []
    for src in srcs:
        obj = emscripten.actions.declare_file(src.basename + ".o")

        args = emscripten.actions.args()
        args.add("-c")
        args.add("-o", obj)
        args.add(src)
        emscripten.actions.run(
            inputs = [src, emscripten.sdk.emcc_py],
            outputs = [obj],
            executable = emscripten.sdk.emcc,
            arguments = [args],
            mnemonic = "EmccCompile",
            env = {
                "EM_CACHE": emscripten.sdk.cache.path,
            },
        )
        objs.append(obj)

    return objs