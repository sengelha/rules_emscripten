load("@rules_emscripten//emscripten:def.bzl", "emcc_module")

emcc_module(
    name = "module",
    srcs = ["lib.c"],
)

# TODO: replace below with a rules_nodejs program that is called
# directly
sh_test(
    name = "test_module",
    srcs = ["test_module.sh"],
    data = [
        "test_module.js",
        ":module",
    ],
)
