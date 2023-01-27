load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def _rules_nodejs_deps():
    pass

def _rules_nodejs():
    _rules_nodejs_deps()
    http_archive(
        name = "rules_nodejs",
        # 5.8.0, latest as of 2022-12-23
        sha256 = "08337d4fffc78f7fe648a93be12ea2fc4e8eb9795a4e6aa48595b66b34555626",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.0/rules_nodejs-core-5.8.0.tar.gz"],
    )

def _aspect_rules_js_deps():
    _rules_nodejs()

def _aspect_rules_js():
    _aspect_rules_js_deps()
    http_archive(
        name = "aspect_rules_js",
        # 1.16.0, latest as of 2023-01-26
        sha256 = "9f51475dd2f99abb015939b1cf57ab5f15ef36ca6d2a67104450893fd0aa5c8b",
        strip_prefix = "rules_js-1.16.0",
        url = "https://github.com/aspect-build/rules_js/archive/refs/tags/v1.16.0.tar.gz",
    )

def _bazel_skylib_deps():
    pass

def _bazel_skylib():
    _bazel_skylib_deps()
    http_archive(
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
    http_archive(
        name = "io_bazel_rules_go",
        sha256 = "2b1641428dff9018f9e85c0384f03ec6c10660d935b750e3fa1492a281a53b0f",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
        ],
    )

def emscripten_rules_dependencies():
    _io_bazel_rules_go()
    _aspect_rules_js()