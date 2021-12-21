def _binary(emscripten, name = "", srcs = []):
    compile_results = emscripten.compile(
        emscripten,
        srcs = srcs
    )

    link_results = emscripten.link(
        emscripten,
        name = name,
        objs = compile_results.objs,
        emit_wasm = True,
    )

    output_arr = [link_results.output_js]
    if link_results.output_wasm:
        output_arr.append(link_results.output_wasm)

    executable = emscripten.actions.declare_file("{}_/binary.sh".format(name))
    emscripten.actions.write(
        output = executable,
        content = """#!/bin/bash

set -euo pipefail

exec node {js_file}""".format(js_file = link_results.output_js.short_path),
        is_executable = True,
    )

    runfiles = emscripten.runfiles(output_arr)

    return struct(
        files = depset(output_arr),
        output_js = link_results.output_js,
        output_wasm = link_results.output_wasm,
        executable = executable,
        runfiles = runfiles,
    )

def _library(emscripten, name = "", srcs = [], modularize = True, emit_wasm = True, pre_js = None, post_js = None, extern_pre_js = None, extern_post_js = None, linkopts = []):
    compile_results = emscripten.compile(
        emscripten,
        srcs = srcs,
    )

    link_results = emscripten.link(
        emscripten,
        name = name,
        objs = compile_results.objs,
        modularize = modularize,
        emit_wasm = emit_wasm,
        pre_js = pre_js,
        post_js = post_js,
        extern_pre_js = extern_pre_js,
        extern_post_js = extern_post_js,
        linkopts = linkopts,
    )

    return struct(
        output_js = link_results.output_js,
        output_wasm = link_results.output_wasm,
    )

def emscripten_context(ctx):
    toolchain = ctx.toolchains["@rules_emscripten//emscripten:toolchain"]
    return struct(
        # Fields
        actions = ctx.actions,
        runfiles = ctx.runfiles,
        toolchain = toolchain,
        sdk = toolchain.sdk,
        # Action generators
        binary = _binary,
        compile = toolchain.actions.compile,
        library = _library,
        link = toolchain.actions.link,
    )