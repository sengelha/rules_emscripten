"Functions for creating emscripten config files"

def create_emconfig(ctx, output_file, cache_root, binaryen_root, emscripten_root, llvm_root, frozen_cache):
    """Create an emconfig file for use with emcc

    Args:
      ctx: The repository context
      output_file: The location of the emconfig file to create
      cache_root: The location of the emscripten cache root
      binaryen_root: The location of the binaryen root
      emscripten_root: The location of the emscripten toolchain
      llvm_root: The location of the LLVM toolchain
      frozen_cache: A bool for whether or not to mark the cache as frozen"""
    if not cache_root.exists:
        fail("cache_root {} does not exist".format(cache_root))
    if not binaryen_root.exists:
        fail("binaryen_root {} does not exist".format(binaryen_root))
    if not emscripten_root.exists:
        fail("emscripten_root {} does not exist".format(emscripten_root))
    if not llvm_root.exists:
        fail("llvm_root {} does not exist".format(llvm_root))

    ctx.template(
        output_file,
        Label("@com_stevenengelhardt_rules_emscripten//emscripten/private:emconfig.sdk"),
        executable = False,
        substitutions = {
            "{cache}": str(cache_root.realpath),
            "{binaryen_root}": str(binaryen_root.realpath),
            "{emscripten_root}": str(emscripten_root.realpath),
            "{llvm_root}": str(llvm_root.realpath),
            "{frozen_cache}": "True" if frozen_cache else "False",
        },
    )
