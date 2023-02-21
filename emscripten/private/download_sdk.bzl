load("//emscripten/private:sdk_list.bzl", "DEFAULT_VERSION", "SDK_REPOSITORIES")
load("emconfig.bzl", "create_emconfig")
load("emscripten_toolchain.bzl", "register_toolchains")
load("platforms.bzl", "detect_host_platform", "is_windows")
load("sdk_build_file.bzl", "create_sdk_build_file")

def _find_cache_dir(ctx):
    if "HOME" in ctx.os.environ:
        home_cache_dir = ctx.path(ctx.os.environ["HOME"] + "/.emscripten_cache")
        if home_cache_dir.exists:
            return home_cache_dir
    return None

def _create_cache_dir(ctx):
    cache_dir = _find_cache_dir(ctx)
    if cache_dir:
        ctx.symlink(cache_dir, "cache")
    else:
        # Implicitly emcc cache directory by creating a sentinel file within it
        ctx.file("cache/.sentinel")

    return ctx.path("cache")

def _symlink_downloaded_emcc_exe(ctx):
    emcc_exe_name = "emcc.bat" if is_windows(ctx) else "emcc"
    emcc_exe_path = ctx.path("emsdk/emscripten/" + emcc_exe_name)
    if not emcc_exe_path.exists:
        fail("Downloaded emcc {} does not exist".format(emcc_exe_path))
    # We need to symlink the entire directory because emcc requires
    # the ability to resolve other files in it
    ctx.symlink(emcc_exe_path.dirname, "bin")
    return ctx.path("bin/" + emcc_exe_name)

def _remote_sdk(ctx, urls, sha256):
    if not urls:
        fail("No urls specified")

    if urls[0].endswith(".tbz2"):
        urltype = "tar.bz2"
    else:
        urltype = ""

    ctx.download_and_extract(
        url = urls,
        sha256 = sha256,
        type = urltype,
        output = "emsdk",
        stripPrefix = "install",
    )

def _emscripten_download_sdk_impl(ctx):
    if ctx.attr.version:
        version = ctx.attr.version
    else:
        version = DEFAULT_VERSION

    emos, emarch = detect_host_platform(ctx)
    platform = emos + "_" + emarch
    sdks = SDK_REPOSITORIES[version]
    url, sha256 = sdks[platform]
    _remote_sdk(ctx, [url], sha256)

    emcc_exe = _symlink_downloaded_emcc_exe(ctx)
    cache_root = _create_cache_dir(ctx)
    binaryen_root = ctx.path("emsdk")
    emscripten_root = ctx.path("emsdk")
    llvm_root = ctx.path("emsdk").get_child("bin")

    create_sdk_build_file(ctx, platform, emcc_exe)
    create_emconfig(ctx, cache_root, binaryen_root, emscripten_root, llvm_root)

    if not ctx.attr.version:
        return {
            "name": ctx.attr.name,
            "version": version,
        }
    return None

_emscripten_download_sdk = repository_rule(
    implementation = _emscripten_download_sdk_impl,
    attrs = {
        "version": attr.string(),
    },
    environ = ["PATH"],
)

def emscripten_download_sdk(name, **kwargs):
    """
    Set up a host emscripten SDK.

    At the end of this function, the workspace looks as follows:
    - BUILD.bazel is created with the appropriate settings
    - .emconfig is created with the appropriate settings
    - bin/emcc (bin/emcc.bat on Windows) points to the downloaded emcc
    - cache/ is a directory or symlink which should be used for
      Emscripten caches
    - emsdk/ has the downloaded Emscripten SDK

    And the toolchain is registered with the system.
    """
    _emscripten_download_sdk(name = name, **kwargs)
    register_toolchains(name)
