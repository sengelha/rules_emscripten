"Functions for supporting preinstalled emcc SDKs."

load("emcc_cache.bzl", "init_emcc_cache")
load("emconfig.bzl", "create_emconfig")
load("emscripten_toolchain.bzl", "register_toolchains")
load("platforms.bzl", "detect_host_platform", "is_windows")
load("sdk_build_file.bzl", "create_sdk_build_file")

def _symlink_sys_emcc_exe(ctx):
    emcc_exe_name = "emcc.bat" if is_windows(ctx) else "emcc"
    emcc_exe_path = ctx.which(emcc_exe_name)
    if not emcc_exe_path:
        fail("Could not find path to {}".format(emcc_exe_name))

    # We need to symlink the entire directory because emcc requires
    # the ability to resolve other files in it
    ctx.symlink(emcc_exe_path.dirname, "bin")
    return ctx.path("bin/" + emcc_exe_name)

def _find_embuilder_exe(ctx):
    embuilder_exe_name = "embuilder.bat" if is_windows(ctx) else "embuilder"
    embuilder_exe_path = ctx.which(embuilder_exe_name)
    if not embuilder_exe_path:
        fail("Could not find path to {}".format(embuilder_exe_path))
    return embuilder_exe_path

def _find_emconfig_exe(ctx):
    emconfig_exe_name = "em-config.bat" if is_windows(ctx) else "em-config"
    emconfig_exe_path = ctx.which(emconfig_exe_name)
    if not emconfig_exe_path:
        fail("Could not find path to {}".format(emconfig_exe_name))
    return emconfig_exe_path

def _find_binaryen_root(ctx):
    em_config_exe = _find_emconfig_exe(ctx)
    res = ctx.execute([em_config_exe, "BINARYEN_ROOT"])
    if res.return_code != 0:
        fail("Could not determine emscripten binaryen_root: " + res.stderr)
    return ctx.path(res.stdout.strip())

def _find_cache_root(ctx):
    em_config_exe = _find_emconfig_exe(ctx)
    res = ctx.execute([em_config_exe, "CACHE"])
    if res.return_code != 0:
        fail("Could not determine emscripten cache root: " + res.stderr)
    return ctx.path(res.stdout.strip())

def _find_emscripten_root(ctx):
    em_config_exe = _find_emconfig_exe(ctx)
    res = ctx.execute([em_config_exe, "EMSCRIPTEN_ROOT"])
    if res.return_code != 0:
        fail("Could not determine emscripten emscripten_root: " + res.stderr)
    return ctx.path(res.stdout.strip())

def _find_llvm_root(ctx):
    em_config_exe = _find_emconfig_exe(ctx)
    res = ctx.execute([em_config_exe, "LLVM_ROOT"])
    if res.return_code != 0:
        fail("Could not determine emscripten llvm_root: " + res.stderr)
    return ctx.path(res.stdout.strip())

def _emscripten_host_sdk_impl(ctx):
    emos, emarch = detect_host_platform(ctx)
    platform = emos + "_" + emarch

    emcc_exe = _symlink_sys_emcc_exe(ctx)
    embuilder_exe = _find_embuilder_exe(ctx)
    cache_root = _find_cache_root(ctx)
    binaryen_root = _find_binaryen_root(ctx)
    emscripten_root = _find_emscripten_root(ctx)
    llvm_root = _find_llvm_root(ctx)

    init_emcc_cache(ctx, embuilder_exe, cache_root, binaryen_root, emscripten_root, llvm_root)
    create_sdk_build_file(ctx, platform, emcc_exe)
    create_emconfig(ctx, ".emconfig", cache_root, binaryen_root, emscripten_root, llvm_root, False)

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
