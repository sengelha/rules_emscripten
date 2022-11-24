def link(emscripten, name, objs, linkopts = [], modularize = False, emit_wasm = False, emit_memory_init_file = False, pre_js = None, post_js = None, extern_pre_js = None, extern_post_js = None, configuration = None):
    emtoolchain = emscripten.toolchains["@com_stevenengelhardt_rules_emscripten//emscripten:toolchain"]
    nodetoolchain = emscripten.toolchains["@rules_nodejs//nodejs:toolchain_type"]

    inputs = objs + [emtoolchain.sdk.emconfig]
    output_js = emscripten.actions.declare_file(name + ".js")
    outputs = [output_js]

    args = emscripten.actions.args()
    args.add("link")
    args.add("-o", output_js)
    args.add("-e", emtoolchain.sdk.emcc)
    args.add("-c", emtoolchain.sdk.emconfig)
    args.add("-n", nodetoolchain.nodeinfo.tool_files[0])
    args.add_joined("-l", linkopts, join_with = ";")
    if not emit_wasm and emit_memory_init_file:
        args.add("-M")
        output_mem_init = emscripten.actions.declare_file(name + ".mem")
        outputs.append(output_mem_init)
    else:
        output_mem_init = None
    if configuration:
        args.add("-C", configuration)
    if modularize:
        args.add("-m")
    if pre_js:
        args.add("-p", pre_js)
        inputs.append(pre_js)
    if post_js:
        args.add("-P", post_js)
        inputs.append(post_js)
    if extern_pre_js:
        args.add("-x", extern_pre_js)
        inputs.append(extern_pre_js)
    if extern_post_js:
        args.add("-X", extern_post_js)
        inputs.append(extern_post_js)
    if emit_wasm:
        args.add("-w")
        output_wasm = emscripten.actions.declare_file(name + ".wasm")
        outputs.append(output_wasm)
    else:
        output_wasm = None
    args.add_all(objs)
    emscripten.actions.run(
        inputs = inputs,
        outputs = outputs,
        executable = emtoolchain._builder,
        arguments = [args],
        tools = [emtoolchain.sdk.emcc] + emtoolchain.sdk.emsdk + nodetoolchain.nodeinfo.tool_files,
        mnemonic = "EmccLink",
        # builder requires PATH to be set
        use_default_shell_env = True,
        # no-sandbox because emcc will write to the repository's cache directory
        execution_requirements = {
            "no-sandbox": "1",
        },
    )

    return struct(
        output_js = output_js,
        output_wasm = output_wasm,
        output_mem_init = output_mem_init,
    )
