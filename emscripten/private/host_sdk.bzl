load("emconfig.bzl", "create_emconfig")
load("emscripten_toolchain.bzl", "register_toolchains")
load("platforms.bzl", "detect_host_platform", "is_windows")
load("sdk_build_file.bzl", "create_sdk_build_file")

def _symlink_sys_emcc_exe(ctx):
    emcc_exe_name = "emcc.bat" if is_windows(ctx) else "emcc"
    emcc_exe_path = ctx.which(emcc_exe_name)
    if not emcc_exe_path:
        fail("Could not find path to {}".format(emcc_exe_name))
    ctx.symlink(emcc_exe_path, "bin/" + emcc_exe_name)

    # Linux machines need emcc.py in same directory as emcc
    emcc_py_path = ctx.which("emcc.py")
    if emcc_py_path:
        ctx.symlink(emcc_py_path, "bin/emcc.py")

    return ctx.path("bin/" + emcc_exe_name)

def _find_binaryen_root(ctx):
    res = ctx.execute(["em-config", "BINARYEN_ROOT"])
    if res.return_code != 0:
        fail("Could not determine emscripten binaryen_root")
    return ctx.path(res.stdout.strip())

def _find_cache_root(ctx):
    res = ctx.execute(["em-config", "CACHE"])
    if res.return_code != 0:
        fail("Could not determine emscripten cache root")
    return ctx.path(res.stdout.strip())

def _find_emscripten_root(ctx):
    res = ctx.execute(["em-config", "EMSCRIPTEN_ROOT"])
    if res.return_code != 0:
        fail("Could not determine emscripten emscripten_root")
    return ctx.path(res.stdout.strip())

def _find_llvm_root(ctx):
    res = ctx.execute(["em-config", "LLVM_ROOT"])
    if res.return_code != 0:
        fail("Could not determine emscripten llvm_root")
    return ctx.path(res.stdout.strip())

def _emscripten_host_sdk_impl(ctx):
    emos, emarch = detect_host_platform(ctx)
    platform = emos + "_" + emarch

    emcc_exe = _symlink_sys_emcc_exe(ctx)
    cache_root = _find_cache_root(ctx)
    binaryen_root = _find_binaryen_root(ctx)
    emscripten_root = _find_emscripten_root(ctx)
    llvm_root = _find_llvm_root(ctx)

    create_sdk_build_file(ctx, platform, emcc_exe)
    create_emconfig(ctx, cache_root, binaryen_root, emscripten_root, llvm_root)

    return None

_emscripten_host_sdk = repository_rule(
    implementation = _emscripten_host_sdk_impl,
    environ = ["HOME"],
)

def emscripten_host_sdk(name, **kwargs):
    """
    Set up a host emscripten SDK.

    At the end of this function, the workspace looks as follows:
    - BUILD.bazel is created with the appropriate settings
    - .emconfig is created with the appropriate settings
    - bin/emcc (bin/emcc.bat on Windows) points to the system emcc

    And the toolchain is registered with the system.
    """
    _emscripten_host_sdk(name = name, **kwargs)
    register_toolchains(name)
