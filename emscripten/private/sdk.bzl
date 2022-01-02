load("//emscripten/private:platforms.bzl", "generate_toolchain_names")
load("//emscripten/private:sdk_list.bzl", "DEFAULT_VERSION", "SDK_REPOSITORIES")

def _detect_host_platform(ctx):
    if ctx.os.name == "linux":
        emos, emarch = "linux", "amd64"
        res = ctx.execute(["uname", "-p"])
        if res.return_code == 0:
            uname = res.stdout.strip()
            if uname == "s390x":
                emarch = "s390x"
            elif uname == "i686":
                emarch = "386"

        # uname -p is not working on Aarch64 boards
        # or for ppc64le on some distros
        res = ctx.execute(["uname", "-m"])
        if res.return_code == 0:
            uname = res.stdout.strip()
            if uname == "aarch64":
                emarch = "arm64"
            elif uname == "armv6l":
                emarch = "arm"
            elif uname == "armv7l":
                emarch = "arm"
            elif uname == "ppc64le":
                emarch = "ppc64le"

        # Default to amd64 when uname doesn't return a known value.

    elif ctx.os.name == "mac os x":
        emos, emarch = "darwin", "amd64"

        res = ctx.execute(["uname", "-m"])
        if res.return_code == 0:
            uname = res.stdout.strip()
            if uname == "arm64":
                emarch = "arm64"

        # Default to amd64 when uname doesn't return a known value.

    elif ctx.os.name.startswith("windows"):
        emos, emarch = "windows", "amd64"
    elif ctx.os.name == "freebsd":
        emos, emarch = "freebsd", "amd64"
    else:
        fail("Unsupported operating system: " + ctx.os.name)

    return emos, emarch

def _is_windows(ctx):
    emos, emarch = _detect_host_platform(ctx)
    return emos == "windows"

def _create_build_file(ctx, platform):
    emos, _, emarch = platform.partition("_")
    ctx.template(
        "BUILD.bazel",
        Label("@rules_emscripten//emscripten/private:BUILD.sdk.bazel"),
        executable = False,
        substitutions = {
            "{emos}": emos,
            "{emarch}": emarch,
            "{emcc}": "emsdk/emscripten/emcc.bat" if _is_windows(ctx) else "emsdk/emscripten/emcc",
        },
    )

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

def _create_emconfig(ctx):
    if "EMSDK" in ctx.os.environ:
        binaryen_root = "{}/upstream".format(ctx.os.environ["EMSDK"])
        emscripten_root = ctx.os.environ["EMSDK"]
        llvm_root = "{}/upstream/bin".format(ctx.os.environ["EMSDK"])
    else:
        binaryen_root = str(ctx.path("emsdk").realpath)
        emscripten_root = str(ctx.path("emsdk").realpath)
        llvm_root = str(ctx.path("emsdk").get_child("bin").realpath)
    
    ctx.template(
        ".emconfig",
        Label("@rules_emscripten//emscripten/private:emconfig.sdk"),
        executable = False,
        substitutions = {
            "{cache}": str(ctx.path("cache").realpath),
            "{binaryen_root}": binaryen_root,
            "{emscripten_root}": emscripten_root,
            "{llvm_root}": llvm_root,
        }
    )

def _detect_host_sdk(ctx):
    if "EMSDK" in ctx.os.environ:
        return ctx.os.environ["EMSDK"]
    fail("Could not find host EMSDK")

def _local_sdk(ctx, emsdk):
    emcc_exe = "emcc.bat" if _is_windows(ctx) else "emcc"
    for exe in [emcc_exe, "emcc.py"]:
        path = ctx.which(exe)
        if not path:
            fail("Could not find path to {}".format(exe))
        ctx.symlink(path, "bin/" + exe)

def _emscripten_host_sdk_impl(ctx):
    emsdk = _detect_host_sdk(ctx)
    emos, emarch = _detect_host_platform(ctx)
    platform = emos + "_" + emarch
    _local_sdk(ctx, emsdk)
    _create_build_file(ctx, platform)
    _create_cache_dir(ctx)
    _create_emconfig(ctx)

_emscripten_host_sdk = repository_rule(
    implementation = _emscripten_host_sdk_impl,
    environ = ["EMSDK", "HOME"],
)

def _register_toolchains(repo):
    labels = [
        "@{}//:{}".format(repo, name)
        for name in generate_toolchain_names()
    ]
    native.register_toolchains(*labels)

def emscripten_host_sdk(name, **kwargs):
    _emscripten_host_sdk(name = name, **kwargs)
    _register_toolchains(name)

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

    sdks = SDK_REPOSITORIES[version]
    emos, emarch = _detect_host_platform(ctx)
    platform = emos + "_" + emarch
    url, sha256 = sdks[platform]
    _remote_sdk(ctx, [url], sha256)
    _create_build_file(ctx, platform)
    _create_cache_dir(ctx)
    _create_emconfig(ctx)

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
    _emscripten_download_sdk(name = name, **kwargs)
    _register_toolchains(name)