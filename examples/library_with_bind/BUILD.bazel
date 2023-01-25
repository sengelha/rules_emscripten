load("@com_stevenengelhardt_rules_emscripten//emscripten:def.bzl", "emcc_library")
load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_test")

emcc_library(
    name = "module",
    srcs = ["lib.cpp"],
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