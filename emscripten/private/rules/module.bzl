load("//emscripten/private:context.bzl", "emscripten_context")

def _impl(ctx):
    emscripten = emscripten_context(ctx)

    js, wasm = emscripten.module(
        emscripten,
        name = ctx.label.name,
        srcs = ctx.files.srcs,
        linkopts = ctx.attr.linkopts,
    )

    return DefaultInfo(
        files = depset([js, wasm]),
        runfiles = emscripten.runfiles([js, wasm]),
    )

emcc_module = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
        "linkopts": attr.string_list(),
    },
    toolchains = ["@rules_emscripten//emscripten:toolchain"],
)
