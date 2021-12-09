load("@rules_emscripten//emscripten:def.bzl", "emcc_module")
load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_test")

emcc_module(
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
)