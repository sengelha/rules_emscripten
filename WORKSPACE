workspace(
    name = "com_stevenengelhardt_rules_emscripten",
)

load(":internal_deps.bzl", "rules_emscripten_internal_deps")

# Fetch deps needed only locally for development
rules_emscripten_internal_deps()

load("@com_stevenengelhardt_rules_emscripten//emscripten:deps.bzl", "emscripten_rules_dependencies")

emscripten_rules_dependencies()

load("@com_stevenengelhardt_rules_emscripten//emscripten:def.bzl", "emscripten_setup")

emscripten_setup(version = "3.1.30")

# --- Setup rules_nodejs and build_bazel_rules_nodejs

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories", "yarn_install")

node_repositories()

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

# --- End setup rules_nodejs and build_bazel_rules_nodejs
