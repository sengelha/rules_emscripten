def create_emconfig(ctx, cache_root, binaryen_root, emscripten_root, llvm_root):
    if not cache_root.exists:
        fail("cache_root {} does not exist".format(cache_root))
    if not binaryen_root.exists:
        fail("binaryen_root {} does not exist".format(binaryen_root))
    if not emscripten_root.exists:
        fail("emscripten_root {} does not exist".format(emscripten_root))
    if not llvm_root.exists:
        fail("llvm_root {} does not exist".format(llvm_root))

    ctx.template(
        ".emconfig",
        Label("@com_stevenengelhardt_rules_emscripten//emscripten/private:emconfig.sdk"),
        executable = False,
        substitutions = {
            "{cache}": str(cache_root.realpath),
            "{binaryen_root}": str(binaryen_root.realpath),
            "{emscripten_root}": str(emscripten_root.realpath),
            "{llvm_root}": str(llvm_root.realpath),
        },
    )
