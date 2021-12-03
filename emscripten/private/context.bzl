def emscripten_context(ctx):
    toolchain = ctx.toolchains["@rules_emscripten//emscripten:toolchain"]
    return struct(
        # Fields
        actions = ctx.actions,
        runfiles = ctx.runfiles,
        toolchain = toolchain,
        sdk = toolchain.sdk,
        # Action generators
        binary = toolchain.actions.binary,
        compile = toolchain.actions.compile,
        link = toolchain.actions.link,
        module = toolchain.actions.module,
    )