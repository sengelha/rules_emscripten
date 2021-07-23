def _impl(ctx):
    headers = depset(
        transitive = [x[CcInfo].compilation_context.headers for x in ctx.attr.deps],
    )
    include_dirs = depset(
        transitive = [x[CcInfo].compilation_context.includes for x in ctx.attr.deps],
    )

    args = ctx.actions.args()
    args.add("-o", ctx.outputs.executable)
    args.add_all("-I", include_dirs)
    args.add_all(ctx.files.srcs)
    ctx.actions.run(
        inputs = depset(
            direct = ctx.files.srcs,
            transitive = [headers],
        ),
        outputs = [ctx.outputs.executable],
        # TODO: Use downloaded toolchain
        executable = "/usr/local/bin/emcc",
        arguments = [args],
        mnemonic = "EmccCompile",
        env = {
            # TODO: Change below
            "EM_CACHE": "/tmp/asdf",
        },
    )

    return DefaultInfo(
        files = depset([ctx.outputs.executable]),
        executable = ctx.outputs.executable,
    )

emcc_binary = rule(
    implementation = _impl,
    executable = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
    },
)
