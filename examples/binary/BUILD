load("@rules_emscripten//emscripten:def.bzl", "emcc_binary")

emcc_binary(
    name = "binary",
    srcs = ["main.cpp"],
)

py_test(
    name = "test_binary",
    srcs = ["test_binary.py"],
    args = ["$(location :binary)"],
    data = [":binary"],
    tags = ["L0"],
)
