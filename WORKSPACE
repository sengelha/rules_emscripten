workspace(
    name = "com_stevenengelhardt_rules_emscripten",
    managed_directories = {"@npm": ["node_modules"]},
)

load(":internal_deps.bzl", "rules_emscripten_internal_deps")

# Fetch deps needed only locally for development
rules_emscripten_internal_deps()

load("@com_stevenengelhardt_rules_emscripten//emscripten:deps.bzl", "emscripten_rules_dependencies")

emscripten_rules_dependencies()

load("@com_stevenengelhardt_rules_emscripten//emscripten:def.bzl", "emscripten_setup")

emscripten_setup(version = "3.1.30")

# --- Load packages used by tests

load("@aspect_rules_js//js:repositories.bzl", "rules_js_dependencies")

rules_js_dependencies()

load("@rules_nodejs//nodejs:repositories.bzl", "DEFAULT_NODE_VERSION", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "nodejs",
    node_version = DEFAULT_NODE_VERSION,
)

load("@aspect_rules_js//npm:npm_import.bzl", "npm_translate_lock")

npm_translate_lock(
    name = "npm",
    pnpm_lock = "//:pnpm-lock.yaml",
    verify_node_modules_ignored = "//:.bazelignore",
)

load("@npm//:repositories.bzl", "npm_repositories")

npm_repositories()

# --- End loading packages used by tests