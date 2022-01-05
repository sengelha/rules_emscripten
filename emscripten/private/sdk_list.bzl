DEFAULT_VERSION = "3.0.1"

SDK_REPOSITORIES = {
    # These are based on https://github.com/emscripten-core/emsdk/blob/main/bazel/revisions.bzl
    "3.0.1": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.tbz2", "52ec2204115b727cc4de38b5eeae147eead12b299b98e5a88653d12958cae4d4"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.tbz2", "25fd430268596229c4ac38e188d7c2b31f75c2ec8172b1351d763e37c830c6af"),
    },
    "3.0.0": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.tbz2", "ebb17bc91c6a72ca06d17337d27aa1a2be4c9af4c68644c221712123f663b8ab"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.tbz2", "10646b64daea15354f14f89f7e79937f420b77f31bda7c4b174de2474835950f"),
    },
    "2.0.34": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.tbz2", "975ae11000100362baf19d161fec04d82e1f7c9fb7d43c43864ddd65a47f1780"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.tbz2", "a6304e3a52c172eb178c6f9817d74aa3ee411e97ef00bcae0884377799c49954"),
    },
}