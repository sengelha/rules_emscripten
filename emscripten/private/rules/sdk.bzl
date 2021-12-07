load("//emscripten/private:providers.bzl", "EmscriptenSDK")

def _impl(ctx):
    return [EmscriptenSDK(
        emos = ctx.attr.emos,
        emarch = ctx.attr.emarch,
        emcc = ctx.executable.emcc,
        emsdk = ctx.files.emsdk,
        emconfig = ctx.file.emconfig,
    )]

emscripten_sdk = rule(
    _impl,
    attrs = {
        "emos": attr.string(
            mandatory = True,
            doc = "The host OS the SDK was built for",
        ),
        "emarch": attr.string(
            mandatory = True,
            doc = "The host architecture the SDK was built for",
        ),
        "emcc": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
            doc = "The emcc binary",
        ),
        "emsdk": attr.label_list(
            mandatory = True,
            allow_files = True,
            doc = "All emscripten SDK files",
        ),
        "emconfig": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The emscripten config file",
        ),
    },
    provides = [EmscriptenSDK],
)