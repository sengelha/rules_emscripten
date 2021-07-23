load("@rules_emscripten//emscripten:def.bzl", "emcc_module")

emcc_module(
    name = "calc",
    srcs = ["lib.cpp"],
)

# TODO: replace below with a javascript program
sh_test(
    name = "test_module",
    srcs = ["test_module.sh"],
    data = [
        "test_module.js",
        ":calc",
    ],
)
