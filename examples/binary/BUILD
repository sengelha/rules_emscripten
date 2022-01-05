load("@rules_emscripten//emscripten:def.bzl", "emcc_binary")

emcc_binary(
    name = "binary",
    srcs = ["main.cpp"],
)

sh_test(
    name = "test_binary",
    srcs = ["test_binary.sh"],
    args = ["$(location :binary)"],
    data = [":binary"],
    tags = ["L0"],
)
