load("emconfig.bzl", "create_emconfig")

def init_emcc_cache(ctx, emcc_exe, cache_root, binaryen_root, emscripten_root, llvm_root):
    if not ctx.which("python3"):
        fail("Could not find python3 in the system PATH")

    create_emconfig(ctx, "cache_init.emconfig", cache_root, binaryen_root, emscripten_root, llvm_root, False)

    ctx.report_progress("warming emcc cache (this can take a while)")
    res = ctx.execute(
        ["python3", "bin/embuilder.py", "build", "MINIMAL"],
        environment={
            "EM_CONFIG": "cache_init.emconfig",
        },
    )
    if res.return_code != 0:
        fail("Initializing emcc cache failed: " + res.stderr)