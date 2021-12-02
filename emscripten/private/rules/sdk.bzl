load("//emscripten/private:providers.bzl", "EmscriptenSDK")

def _impl(ctx):
    return [EmscriptenSDK(
        emos = ctx.attr.emos,
        emarch = ctx.attr.emarch,
        root_file = ctx.file.root_file,
        emsdk = ctx.files.emsdk,
        cache = ctx.file.cache,
        emcc = ctx.executable.emcc,
        emcc_py = ctx.executable.emcc_py,
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
        "root_file": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "A file in the SDK root directory. Used to determine EMSDK.",
        ),
        "emsdk": attr.label_list(
            allow_files = True,
            cfg = "exec",
            doc = "All EMSDK files",
        ),
        "cache": attr.label(
            allow_single_file = True,
            cfg = "exec",
            doc = "Directory for cached output",
        ),
        "emcc": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
            doc = "The emcc binary",
        ),
        "emcc_py": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
            doc = "The emcc.py binary",
        ),
    },
    provides = [EmscriptenSDK],
)