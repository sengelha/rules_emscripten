load("@rules_emscripten//emscripten/private:rules/binary.bzl", _emcc_binary = "emcc_binary")
load("@rules_emscripten//emscripten/private:rules/module.bzl", _emcc_module = "emcc_module")

emcc_binary = _emcc_binary
emcc_module = _emcc_module
