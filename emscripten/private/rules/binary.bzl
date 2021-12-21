load("//emscripten/private:context.bzl", "emscripten_context")

def _impl(ctx):
    emscripten = emscripten_context(ctx)

    results = emscripten.binary(
        emscripten,
        name = ctx.label.name,
        srcs = ctx.files.srcs,
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
    },
    toolchains = [
        "@rules_emscripten//emscripten:toolchain",
        "@build_bazel_rules_nodejs//toolchains/node:toolchain_type",
    ],
)
