load("emconfig.bzl", "create_emconfig")

def _find_python3(ctx):
    sys_python3 = ctx.which("python3")
    if sys_python3:
        return sys_python3

    # Is python actually python3?
    sys_python = ctx.which("python")
    if sys_python:
        res = ctx.execute([sys_python, "--version"])
        if res.return_code == 0:
            if res.stdout.startswith("Python 3."):
                return sys_python

    return None

def init_emcc_cache(ctx, emcc_exe, cache_root, binaryen_root, emscripten_root, llvm_root):
    python3_exe = _find_python3(ctx)
    if not python3_exe:
        fail("Could not find python3 in the system PATH")

    create_emconfig(ctx, "cache_init.emconfig", cache_root, binaryen_root, emscripten_root, llvm_root, False)

    ctx.report_progress("warming emcc cache (this can take a while)")
    res = ctx.execute(
        [python3_exe, "bin/embuilder.py", "build", "MINIMAL"],
        environment={
            "EM_CONFIG": "cache_init.emconfig",
        },
    )
    if res.return_code != 0:
        fail("Initializing emcc cache failed: " + res.stderr)