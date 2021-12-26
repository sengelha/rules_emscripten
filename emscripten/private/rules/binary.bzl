load("//emscripten/private:context.bzl", "emscripten_context")

def _impl(ctx):
    emscripten = emscripten_context(ctx)

    # Determine the actual build configuration from the combination of
    # ctx.attr.configuration and --compilation_mode
    if ctx.attr.configuration:
        configuration = ctx.attr.configuration
    elif ctx.var["COMPILATION_MODE"]:
        configuration = ctx.var["COMPILATION_MODE"] # Could be one of fastbuild, dbg, or opt
    else:
        fail("Could not determine a build configuration")

    results = emscripten.binary(
        emscripten,
        name = ctx.label.name,
        srcs = ctx.files.srcs,
        emit_wasm = ctx.attr.emit_wasm,
        emit_memory_init_file = ctx.attr.emit_memory_init_file,
        configuration = configuration,
    )

    return DefaultInfo(
        files = results.files,
        executable = results.executable,
        runfiles = results.runfiles,
    )

emcc_binary = rule(
    implementation = _impl,
    executable = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "emit_wasm": attr.bool(default = True),
        "emit_memory_init_file": attr.bool(default = True),
        "configuration": attr.string(mandatory = False),
    },
    toolchains = [
        "@rules_emscripten//emscripten:toolchain",
        "@build_bazel_rules_nodejs//toolchains/node:toolchain_type",
    ],
)
