load("//emscripten/private:context.bzl", "emscripten_context")

def _impl(ctx):
    emscripten = emscripten_context(ctx)

    js, wasm, executable, runfiles = emscripten.binary(
        emscripten,
        name = ctx.label.name,
        srcs = ctx.files.srcs,
    )

    return DefaultInfo(
        files = depset([js, wasm]),
        executable = executable,
        runfiles = runfiles,
    )

emcc_binary = rule(
    implementation = _impl,
    executable = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [CcInfo]),
    },
    toolchains = ["@rules_emscripten//emscripten:toolchain"],
)
