def _impl(ctx):
    headers = depset(
        transitive = [x[CcInfo].compilation_context.headers for x in ctx.attr.deps],
    )
    include_dirs = depset(
        transitive = [x[CcInfo].compilation_context.includes for x in ctx.attr.deps],
    )

    output_file = ctx.actions.declare_file(ctx.label.name + ".js")

    args = ctx.actions.args()
    args.add("-o", output_file)
    args.add_all("-I", include_dirs)
    args.add_all(ctx.files.srcs)
    ctx.actions.run(
        inputs = depset(
            direct = ctx.files.srcs,
            transitive = [headers],
        ),
        outputs = [output_file],
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
        files = depset([output_file]),
        runfiles = ctx.runfiles(files = [output_file]),
    )

emcc_module = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
    },
)
