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
        name = "git_chglog_linux_amd64",
        # Latest as of 2022-01-05
        url = "https://github.com/git-chglog/git-chglog/releases/download/v0.15.1/git-chglog_0.15.1_linux_amd64.tar.gz",
        sha256 = "5247e4602bac520e92fca317322fe716968a27aab1d91706f316627e3a3ee8e6",
        build_file = "@//third_party/git_chglog:git_chglog.BUILD",
    )

    http_archive(
        name = "git_chglog_darwin_arm64",
        # Latest as of 2022-01-05
        url = "https://github.com/git-chglog/git-chglog/releases/download/v0.15.1/git-chglog_0.15.1_darwin_arm64.tar.gz",
        sha256 = "cf0d75dffe49d4c161ba2d0e93f704f218b0790642e4b05091b2ba54e74b1e7a",
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

    http_archive(
        name = "build_bazel_rules_nodejs",
        # 5.8.0, latest as of 2022-12-23
        sha256 = "dcc55f810142b6cf46a44d0180a5a7fb923c04a5061e2e8d8eb05ccccc60864b",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.0/rules_nodejs-5.8.0.tar.gz"],
    )

    http_archive(
        name = "buildifier_prebuilt",
	# 6.1.0, latest as of 2023-07-03
        sha256 = "e46c16180bc49487bfd0f1ffa7345364718c57334fa0b5b67cb5f27eba10f309",
        strip_prefix = "buildifier-prebuilt-6.1.0",
        urls = [
            "http://github.com/keith/buildifier-prebuilt/archive/6.1.0.tar.gz",
        ],
    )
