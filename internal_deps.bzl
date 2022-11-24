"""Our "development" dependencies
Users should *not* need to install these. If users see a load()
statement from these, that's a bug in our distribution.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def rules_emscripten_internal_deps():
    "Fetch deps needed for local development"
    http_archive(
        name = "build_bazel_rules_nodejs",
        # 5.7.1, latest as of 2022-11-23.  Should be kept in sync with
        # rules_nodejs from //emscripten/private:repositories.bzl.
        sha256 = "5aae76dced38f784b58d9776e4ab12278bc156a9ed2b1d9fcd3e39921dc88fda",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.7.1/rules_nodejs-5.7.1.tar.gz"],
    )

    http_archive(
        name = "git_chglog_linux_amd64",
        # Latest as of 2022-01-05
        url = "https://github.com/git-chglog/git-chglog/releases/download/v0.15.1/git-chglog_0.15.1_linux_amd64.tar.gz",
        sha256 = "5247e4602bac520e92fca317322fe716968a27aab1d91706f316627e3a3ee8e6",
        build_file = "@//third_party/git_chglog:git_chglog.BUILD",
    )

    http_archive(
        name = "io_bazel_stardoc",
        sha256 = "05fb57bb4ad68a360470420a3b6f5317e4f722839abc5b17ec4ef8ed465aaa47",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/0.5.2/stardoc-0.5.2.tar.gz",
            "https://github.com/bazelbuild/stardoc/releases/download/0.5.2/stardoc-0.5.2.tar.gz",
        ],
    )

    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "1cbbf62315d303c8083d5019a4657623d4f58e925fb51bdc8a41bad4a131f5c9",
        strip_prefix = "bazel-lib-1.8.1",
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v1.8.1.tar.gz",
    )