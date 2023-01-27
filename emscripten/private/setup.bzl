load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@rules_nodejs//nodejs:repositories.bzl", "nodejs_register_toolchains")
load(":host_sdk.bzl", "emscripten_host_sdk")
load(":download_sdk.bzl", "emscripten_download_sdk")

def _setup_deps():
    go_rules_dependencies()
    go_register_toolchains(version = "1.17.1")
    nodejs_register_toolchains(name = "node16", node_version = "16.5.0")

def emscripten_setup(version = None):
    _setup_deps()

    if version == "host":
        emscripten_host_sdk(name = "emscripten_sdk")
    else:
        emscripten_download_sdk(
            name = "emscripten_sdk",
            version = version,
        )
