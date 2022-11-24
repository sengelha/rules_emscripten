def compile(emscripten, name, srcs, configuration):
    emtoolchain = emscripten.toolchains["@com_stevenengelhardt_rules_emscripten//emscripten:toolchain"]
    nodetoolchain = emscripten.toolchains["@rules_nodejs//nodejs:toolchain_type"]

    objs = []
    for src in srcs:
        if src.basename.endswith(".hpp"):
            continue
        obj = emscripten.actions.declare_file("{}_/{}.o".format(name, src.path))

        args = emscripten.actions.args()
        args.add("compile")
        args.add("-o", obj)
        args.add("-e", emtoolchain.sdk.emcc)
        args.add("-c", emtoolchain.sdk.emconfig)
        args.add("-n", nodetoolchain.nodeinfo.tool_files[0])
        if configuration:
            args.add("-C", configuration)
        args.add(src)
        emscripten.actions.run(
            inputs = [src, emtoolchain.sdk.emconfig],
            outputs = [obj],
            executable = emtoolchain._builder,
            arguments = [args],
            tools = [emtoolchain.sdk.emcc] + emtoolchain.sdk.emsdk + nodetoolchain.nodeinfo.tool_files,
            mnemonic = "EmccCompile",
            # builder requires PATH to be set
            use_default_shell_env = True,
            # no-sandbox because emcc will write to the repository's cache directory
            execution_requirements = {
                "no-sandbox": "1",
            },
        )
        objs.append(obj)

    return struct(
        objs = objs,
    )
