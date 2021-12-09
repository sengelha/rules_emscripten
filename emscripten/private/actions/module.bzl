def emit_module(emscripten, name = "", srcs = [], linkopts = []):
    objs = emscripten.compile(
        emscripten,
        srcs = srcs
    )

    js, wasm = emscripten.link(
        emscripten,
        name = name,
        objs = objs,
        linkopts = linkopts,
        modularize = True,
    )

    return js, wasm