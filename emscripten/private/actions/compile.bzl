def compile(emscripten, srcs):
    emtoolchain = emscripten.toolchains["@rules_emscripten//emscripten:toolchain"]
    nodetoolchain = emscripten.toolchains["@build_bazel_rules_nodejs//toolchains/node:toolchain_type"]

    objs = []
    for src in srcs:
        if src.basename.endswith(".hpp"):
            continue
        obj = emscripten.actions.declare_file(src.basename + ".o")

        args = emscripten.actions.args()
        args.add("compile")
        args.add("-o", obj)
        args.add("-e", emtoolchain.sdk.emcc)
        args.add("-c", emtoolchain.sdk.emconfig)
        args.add("-n", nodetoolchain.nodeinfo.tool_files[0])
        args.add(src)
        emscripten.actions.run(
            inputs = [src, emtoolchain.sdk.emconfig],
            outputs = [obj],
            executable = emtoolchain._builder,
            arguments = [args],
            tools = [emtoolchain.sdk.emcc] + emtoolchain.sdk.emsdk + nodetoolchain.nodeinfo.tool_files,
            mnemonic = "EmccCompile",
            # no-sandbox because emcc will write to the repository's cache directory
            execution_requirements = {
                "no-sandbox": "1",
            },
        )
        objs.append(obj)

    return struct(
        objs = objs,
    )
