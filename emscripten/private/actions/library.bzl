def emit_library(emscripten, name = "", srcs = [], modularize = True, emit_wasm = True, pre_js = None, post_js = None, extern_pre_js = None, extern_post_js = None, linkopts = []):
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
