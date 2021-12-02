EmscriptenSDK = provider(
    doc = "Contains information about the Emscripten SDK used in the toolchain",
    fields = {
        "emos": "The host OS the SDK was built for.",
        "emarch": "The host architecture the SDK was built for.",
        "root_file": "A file in the SDK root directory",
        "emsdk": "All EMSDK files",
        "cache": "The cache directory",
        "emcc": "The emcc binary file",
        "emcc_py": "The emcc.py binary file",
    },
)