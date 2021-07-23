load("@rules_emscripten//emscripten:def.bzl", "emcc_module")

emcc_module(
    name = "c_module",
    srcs = ["lib.c"],
)

# TODO: replace below with a rules_nodejs program that is called
# directly
sh_test(
    name = "test_c_module",
    srcs = ["test_c_module.sh"],
    data = [
        "test_c_module.js",
        ":c_module",
    ],
)
