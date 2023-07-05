"Functions for creating workspace BUILD.bazel files"

def create_sdk_build_file(ctx, platform, emcc_exe):
    """Creates the workspace build file from the template.

    Args:
      ctx: A repository context
      platform: A platform string in the form os_XXX_arch
      emcc_exe: The emcc executable"""
    if not emcc_exe.exists:
        fail("emcc_exe {} does not exist".format(emcc_exe))
    if emcc_exe != ctx.path("bin/" + emcc_exe.basename):
        fail("emcc_exe {} not in expected path bin/{}".format(emcc_exe, emcc_exe.basename))

    emos, _, emarch = platform.partition("_")
    ctx.template(
        "BUILD.bazel",
        Label("@com_stevenengelhardt_rules_emscripten//emscripten/private:BUILD.sdk.bazel"),
        executable = False,
        substitutions = {
            "{emos}": emos,
            "{emarch}": emarch,
            "{emcc}": "bin/" + emcc_exe.basename,
        },
    )
