load("@rules_emscripten//emscripten/private:repositories.bzl", _emscripten_rules_dependencies = "emscripten_rules_dependencies")
load("@rules_emscripten//emscripten/private:sdk.bzl", _emscripten_setup = "emscripten_setup")

emscripten_rules_dependencies = _emscripten_rules_dependencies
emscripten_setup = _emscripten_setup