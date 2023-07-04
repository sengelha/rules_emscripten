"Public API re-exports"

load(
    "//emscripten/private:emscripten_toolchain.bzl",
    _declare_toolchains = "declare_toolchains",
    _emscripten_toolchain = "emscripten_toolchain",
)
load("//emscripten/private/rules:binary.bzl", _emcc_binary = "emcc_binary")
load("//emscripten/private/rules:library.bzl", _emcc_library = "emcc_library")
load("//emscripten/private/rules:sdk.bzl", _emscripten_sdk = "emscripten_sdk")
load("@com_stevenengelhardt_rules_emscripten//emscripten/private:setup.bzl", _emscripten_setup = "emscripten_setup")

declare_toolchains = _declare_toolchains
emcc_binary = _emcc_binary
emcc_library = _emcc_library
emscripten_sdk = _emscripten_sdk
emscripten_setup = _emscripten_setup
emscripten_toolchain = _emscripten_toolchain
