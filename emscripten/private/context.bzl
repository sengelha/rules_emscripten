def _binary(emscripten, name = "", srcs = [], emit_wasm = True, emit_memory_init_file = True, configuration = "fastbuild"):
    nodetoolchain = emscripten.toolchains["@build_bazel_rules_nodejs//toolchains/node:toolchain_type"]

    compile_results = emscripten.compile(
        emscripten,
        name = name,
        srcs = srcs,
        configuration = configuration,
    )

    link_results = emscripten.link(
        emscripten,
        name = name,
        objs = compile_results.objs,
        emit_wasm = emit_wasm,
        emit_memory_init_file = emit_memory_init_file,
        configuration = configuration,
    )

    output_arr = [link_results.output_js]
    if link_results.output_wasm:
        output_arr.append(link_results.output_wasm)
    if link_results.output_mem_init:
        output_arr.append(link_results.output_mem_init)

    executable = emscripten.actions.declare_file("{}_/binary.sh".format(name))
    emscripten.actions.write(
        output = executable,
        content = """#!/bin/bash

set -euo pipefail

exec {node} {js_file}""".format(
            node = nodetoolchain.nodeinfo.tool_files[0].path,
            js_file = link_results.output_js.short_path
        ),
        is_executable = True,
    )

    runfiles = emscripten.runfiles(output_arr + nodetoolchain.nodeinfo.tool_files)

    return struct(
        files = depset(output_arr),
        output_js = link_results.output_js,
        output_wasm = link_results.output_wasm,
        output_mem_init = link_results.output_mem_init,
        executable = executable,
        runfiles = runfiles,
    )

def _library(emscripten, name = "", srcs = [], modularize = True, emit_wasm = True, emit_memory_init_file = True, pre_js = None, post_js = None, extern_pre_js = None, extern_post_js = None, linkopts = [], configuration = None):
    compile_results = emscripten.compile(
        emscripten,
        name = name,
        srcs = srcs,
        configuration = configuration,
    )

    link_results = emscripten.link(
        emscripten,
        name = name,
        objs = compile_results.objs,
        modularize = modularize,
        emit_wasm = emit_wasm,
        emit_memory_init_file = emit_memory_init_file,
        pre_js = pre_js,
        post_js = post_js,
        extern_pre_js = extern_pre_js,
        extern_post_js = extern_post_js,
        linkopts = linkopts,
        configuration = configuration,
    )

    return struct(
        output_js = link_results.output_js,
        output_wasm = link_results.output_wasm,
        output_mem_init = link_results.output_mem_init,
    )

def emscripten_context(ctx):
    emtoolchain = ctx.toolchains["@rules_emscripten//emscripten:toolchain"]

    return struct(
        # Fields
        actions = ctx.actions,
        attr = ctx.attr,
        file = ctx.file,
        runfiles = ctx.runfiles,
        toolchains = ctx.toolchains,
        # Action generators
        binary = _binary,
        compile = emtoolchain.actions.compile,
        library = _library,
        link = emtoolchain.actions.link,
    )