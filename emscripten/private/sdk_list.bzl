DEFAULT_VERSION = "3.1.0"

SDK_REPOSITORIES = {
    # These are based on https://github.com/emscripten-core/emsdk/blob/main/bazel/revisions.bzl
    "3.1.0": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/562e3a0af169e6dea5e6dbecac2255d67c2c8b94/wasm-binaries.tbz2", "f6c1cad729ed799e1df09eacf5aa80cce9861d69ec6d9581c17e4ba8d9b064ce"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/562e3a0af169e6dea5e6dbecac2255d67c2c8b94/wasm-binaries.tbz2", "0714344e32e244e6d44d9ea75937633ab1338e417a232fb66d6dcd7d4b704e8c"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/562e3a0af169e6dea5e6dbecac2255d67c2c8b94/wasm-binaries.zip", "756c41cbcab4ae6077cca30834d16151392b8c19ab186c13d42d7d05d6d727cc"),
    },
    "3.0.1": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.tbz2", "52ec2204115b727cc4de38b5eeae147eead12b299b98e5a88653d12958cae4d4"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.tbz2", "25fd430268596229c4ac38e188d7c2b31f75c2ec8172b1351d763e37c830c6af"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.zip", "0e072736b471c9a07cdf534ba4da46b3b6545b63c8a6cbb0ef7d544251e15092"),
    },
    "3.0.0": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.tbz2", "ebb17bc91c6a72ca06d17337d27aa1a2be4c9af4c68644c221712123f663b8ab"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.tbz2", "10646b64daea15354f14f89f7e79937f420b77f31bda7c4b174de2474835950f"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.zip", "0d4f2ff5d88a8eef5ed769ee4ffc5d5574143911d2e0079325cdc5206c9e9bb1"),
    },
    "2.0.34": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.tbz2", "975ae11000100362baf19d161fec04d82e1f7c9fb7d43c43864ddd65a47f1780"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.tbz2", "a6304e3a52c172eb178c6f9817d74aa3ee411e97ef00bcae0884377799c49954"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.zip", "8167a44bb895a0fdc153836bed91bf387be57f2dc1b8f103bf70e68923b61d39"),
    },
}