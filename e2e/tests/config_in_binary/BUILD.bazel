load("@com_stevenengelhardt_rules_emscripten//emscripten:def.bzl", "emcc_binary")

CONFIGS = [
    "opt",
    "dbg",
    "fastbuild",
]

[emcc_binary(
    name = "{}_binary".format(conf),
    srcs = ["main.cpp"],
    configuration = conf,
) for conf in CONFIGS]

[py_test(
    name = "test_{}_binary".format(conf),
    srcs = ["test_binary.py"],
    main = "test_binary.py",
    args = ["$(location :{}_binary)".format(conf)],
    data = [":{}_binary".format(conf)],
    tags = ["L0"],
) for conf in CONFIGS]
