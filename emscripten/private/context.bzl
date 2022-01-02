def _binary(emscripten, name = "", srcs = [], emit_wasm = True, emit_memory_init_file = True, configuration = "fastbuild", is_windows = False):
    emtoolchain = emscripten.toolchains["@rules_emscripten//emscripten:toolchain"]
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

    runfiles_arr = output_arr + nodetoolchain.nodeinfo.tool_files
    if is_windows:
        runfiles_arr.append(emtoolchain._launcher)
        executable = emscripten.actions.declare_file("{}_/launcher.bat".format(name))
        emscripten.actions.write(
            output = executable,
            content = """@echo off
setlocal

if "%RUNFILES_MANIFEST_FILE%"=="" (
    set RUNFILES_MANIFEST_FILE=MANIFEST
)

if not exist %RUNFILES_MANIFEST_FILE% (
    echo ERROR: %RUNFILES_MANIFEST_FILE% file not found 1>&2
    exit /b 1
)

for /f "tokens=1,2" %%a in (%RUNFILES_MANIFEST_FILE%) do (
    if "%%a" == "emscripten_sdk/launcher_/launcher.exe" (
        "%%b" -n {node} -e rules_emscripten/{js_file}
        exit /b
    )
)

echo ERROR: Launcher not found
exit /b 1""".format(
                node = nodetoolchain.nodeinfo.target_tool_path,
                js_file = link_results.output_js.short_path,
            ),
            is_executable = True,
        )
    else:
        executable = emscripten.actions.declare_file("{}_/launcher.sh".format(name))
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
    runfiles = emscripten.runfiles(files = runfiles_arr)

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