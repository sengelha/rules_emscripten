load("@rules_emscripten//emscripten/private:rules/binary.bzl", _emcc_binary = "emcc_binary")
load("@rules_emscripten//emscripten/private:rules/library.bzl", _emcc_library = "emcc_library")

emcc_binary = _emcc_binary
emcc_library = _emcc_library
