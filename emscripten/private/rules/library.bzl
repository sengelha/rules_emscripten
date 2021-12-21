load("//emscripten/private:context.bzl", "emscripten_context")

def _impl(ctx):
    emscripten = emscripten_context(ctx)

    results = emscripten.library(
        emscripten,
        name = ctx.label.name,
        srcs = ctx.files.srcs,
        modularize = ctx.attr.modularize,
        emit_wasm = ctx.attr.emit_wasm,
        pre_js = ctx.file.pre_js,
        post_js = ctx.file.post_js,
        extern_pre_js = ctx.file.extern_pre_js,
        extern_post_js = ctx.file.extern_post_js,
        linkopts = ctx.attr.linkopts,
    )

    generated_files = [results.output_js]
    if results.output_wasm:
        generated_files.append(results.output_wasm)
    
    return DefaultInfo(
        files = depset(generated_files),
        runfiles = emscripten.runfiles(generated_files),
    )

emcc_library = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "modularize": attr.bool(default = True),
        "emit_wasm": attr.bool(default = True),
        "pre_js": attr.label(allow_single_file = True),
        "post_js": attr.label(allow_single_file = True),
        "extern_pre_js": attr.label(allow_single_file = True),
        "extern_post_js": attr.label(allow_single_file = True),
        "linkopts": attr.string_list(),
    },
    toolchains = [
        "@rules_emscripten//emscripten:toolchain",
        "@build_bazel_rules_nodejs//toolchains/node:toolchain_type",
    ],
)
