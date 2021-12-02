load("//emscripten/private:platforms.bzl", "generate_toolchain_names")

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

def _sdk_build_file(ctx, platform):
    ctx.file("ROOT")
    emos, _, emarch = platform.partition("_")
    ctx.template(
        "BUILD.bazel",
        Label("@rules_emscripten//emscripten/private:BUILD.sdk.bazel"),
        executable = False,
        substitutions = {
            "{emos}": emos,
            "{emarch}": emarch,
            "{exe}": ".exe" if emos == "windows" else "",
        },
    )

def _detect_host_sdk(ctx):
    if "EMSDK" in ctx.os.environ:
        return ctx.os.environ["EMSDK"]
    fail("Could not find host EMSDK")

def _find_cache_dir(ctx):
    if "HOME" in ctx.os.environ:
        home_cache_dir = ctx.path(ctx.os.environ["HOME"] + "/.emscripten_cache")
        if home_cache_dir.exists:
            return home_cache_dir
    return None

def _local_sdk(ctx, emsdk):
    for entry in ["upstream"]:
        ctx.symlink(emsdk + "/" + entry, "sdk/" + entry)

    for exe in ["emcc", "emcc.py"]:
        path = ctx.which(exe)
        if not path:
            fail("Could not find path to {}", exe)
        ctx.symlink(path, "bin/" + exe)

    res = ctx.execute(["mkdir", "cache"])
    if res.return_code:
        fail("Failed to create cache directory")

def _emscripten_host_sdk_impl(ctx):
    emsdk = _detect_host_sdk(ctx)
    emos, emarch = _detect_host_platform(ctx)
    platform = emos + "_" + emarch
    _sdk_build_file(ctx, platform)
    _local_sdk(ctx, emsdk)

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

def emscripten_setup(version = None):
    if version == "host":
        emscripten_host_sdk(name = "emscripten_sdk")
    else:
        fail("Version {} not understood".format(version))