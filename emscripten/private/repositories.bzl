load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def _build_bazel_rules_nodejs_deps():
    pass

def _build_bazel_rules_nodejs():
    _build_bazel_rules_nodejs_deps()
    maybe(
        http_archive,
        name = "build_bazel_rules_nodejs",
        # 4.4.6, latest as of 2021-12-08
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.4.6/rules_nodejs-4.4.6.tar.gz"],
        sha256 = "cfc289523cf1594598215901154a6c2515e8bf3671fd708264a6f6aefe02bf39",
    )

def _bazel_skylib_deps():
    pass

def _bazel_skylib():
    _bazel_skylib_deps()
    maybe(
        http_archive,
        name = "bazel_skylib",
        # 1.1.1, latest as of 2021-10-06
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        ],
        sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
        strip_prefix = "",
    )

def _io_bazel_rules_go_deps():
    _bazel_skylib()

def _io_bazel_rules_go():
    _io_bazel_rules_go_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        sha256 = "2b1641428dff9018f9e85c0384f03ec6c10660d935b750e3fa1492a281a53b0f",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
        ],
    )

def emscripten_rules_dependencies():
    _io_bazel_rules_go()
    _build_bazel_rules_nodejs()