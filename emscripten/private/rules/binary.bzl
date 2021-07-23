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

    # TODO: change options based on -c opt
    args.add("-O0")
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

    bin_wrapper = ctx.actions.declare_file(ctx.label.name + "%/bin_wrapper.sh")

    # TODO: change node to use a downloaded toolchain
    ctx.actions.write(
        output = bin_wrapper,
        content = """#!/bin/bash

set -euo pipefail

node {output_file}
""".format(output_file = output_file.short_path),
        is_executable = True,
    )

    return DefaultInfo(
        files = depset([output_file]),
        executable = bin_wrapper,
        runfiles = ctx.runfiles(files = [output_file]),
    )

emcc_binary = rule(
    implementation = _impl,
    executable = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [CcInfo]),
    },
)
