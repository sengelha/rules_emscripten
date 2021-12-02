def emscripten_context(ctx):
    toolchain = ctx.toolchains["@rules_emscripten//emscripten:toolchain"]
    return struct(
        # Fields
        actions = ctx.actions,
        runfiles = ctx.runfiles,
        sdk = toolchain.sdk,
        # Action generators
        binary = toolchain.actions.binary,
        module = toolchain.actions.module,
    )