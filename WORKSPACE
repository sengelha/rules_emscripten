workspace(
    name = "rules_emscripten",
    managed_directories = {"@npm": ["node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_emscripten//emscripten:deps.bzl", "emscripten_rules_dependencies")

emscripten_rules_dependencies()

load("@rules_emscripten//emscripten:def.bzl", "emscripten_setup")

emscripten_setup(version = "3.1.0")

# --- Begin build_bazel_rules_nodejs (used by examples)
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "cfc289523cf1594598215901154a6c2515e8bf3671fd708264a6f6aefe02bf39",
    # 4.4.6, latest as of 2021-12-08
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.4.6/rules_nodejs-4.4.6.tar.gz"],
)

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories", "yarn_install")

node_repositories(package_json = ["//:package.json"])

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)
# --- End build_bazel_rules_nodejs

# --- Begin git_chglog support
http_archive(
    name = "git_chglog_linux_amd64",
    # Latest as of 2022-01-05
    url = "https://github.com/git-chglog/git-chglog/releases/download/v0.15.1/git-chglog_0.15.1_linux_amd64.tar.gz",
    sha256 = "5247e4602bac520e92fca317322fe716968a27aab1d91706f316627e3a3ee8e6",
    build_file = "@//third_party/git_chglog:git_chglog.BUILD",
)
# --- End git_chglog