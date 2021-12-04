def emit_module(emscripten, name = "", srcs = []):
    objs = emscripten.compile(
        emscripten,
        srcs = srcs
    )

    js, wasm = emscripten.link(
        emscripten,
        name = name,
        objs = objs,
        modularize = True,
    )

    return js, wasm