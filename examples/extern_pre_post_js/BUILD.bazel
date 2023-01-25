load("@com_stevenengelhardt_rules_emscripten//emscripten:def.bzl", "emcc_library")
load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_test")

emcc_library(
    name = "module",
    srcs = ["lib.cpp"],
    modularize = False,
    emit_wasm = False,
    emit_memory_init_file = False,
    extern_pre_js = "pre.js",
    extern_post_js = "post.js",
    linkopts = ["--bind"],
)

nodejs_test(
    name = "test_module",
    data = [
        ":module",
        "@npm//tape",
    ],
    entry_point = "test_module.js",
    templated_args = ["$(rootpaths :module)"],
    tags = ["L0"],
)