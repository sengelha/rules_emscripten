load("//emscripten/private:context.bzl", "emscripten_context")

def _impl(ctx):
    emscripten = emscripten_context(ctx)

    # Determine the actual build configuration from the combination of
    # ctx.attr.configuration and --compilation_mode
    if ctx.attr.configuration:
        configuration = ctx.attr.configuration
    elif ctx.var["COMPILATION_MODE"]:
        configuration = ctx.var["COMPILATION_MODE"]  # Could be one of fastbuild, dbg, or opt
    else:
        fail("Could not determine a build configuration")

    results = emscripten.binary(
        emscripten,
        name = ctx.label.name,
        srcs = ctx.files.srcs,
        emit_wasm = ctx.attr.emit_wasm,
        emit_memory_init_file = ctx.attr.emit_memory_init_file,
        configuration = configuration,
        is_windows = ctx.attr.private_is_windows,
    )

    return DefaultInfo(
        files = results.files,
        executable = results.executable,
        runfiles = results.runfiles,
    )

_emcc_binary = rule(
    implementation = _impl,
    executable = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "emit_wasm": attr.bool(default = True),
        "emit_memory_init_file": attr.bool(default = True),
        "configuration": attr.string(mandatory = False),
        "private_is_windows": attr.bool(mandatory = True),
        "_launcher_cmd": attr.label(
            default = "@com_stevenengelhardt_rules_emscripten//emscripten/private/templates:launcher.cmd",
            allow_single_file = True,
        ),
        "_launcher_sh": attr.label(
            default = "@com_stevenengelhardt_rules_emscripten//emscripten/private/templates:launcher.sh",
            allow_single_file = True,
        ),
    },
    toolchains = [
        "@com_stevenengelhardt_rules_emscripten//emscripten:toolchain",
        "@rules_nodejs//nodejs:toolchain_type",
    ],
)

def emcc_binary(name, **kwargs):
    _emcc_binary(
        name = name,
        private_is_windows = select({
            "@bazel_tools//src/conditions:host_windows": True,
            "//conditions:default": False,
        }),
        **kwargs
    )
