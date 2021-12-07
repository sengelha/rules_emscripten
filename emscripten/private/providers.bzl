EmscriptenSDK = provider(
    doc = "Contains information about the Emscripten SDK used in the toolchain",
    fields = {
        "emos": "The host OS the SDK was built for.",
        "emarch": "The host architecture the SDK was built for.",
        "emcc": "The emcc binary file",
        "emconfig": "The emscripten config file",
        "emsdk": "The Emscripten SDK files",
    },
)