DEFAULT_VERSION = "3.1.30"

SDK_REPOSITORIES = {
    # These are based on https://github.com/emscripten-core/emsdk/blob/main/bazel/revisions.bzl
    "3.1.30": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/dc1fdcfd3f5b9d29cb1ebdf15e6e845bef9b0cc1/wasm-binaries.tbz2", "f0cdbc676c58bce7a65572418fb1521665ed522d7d05ae90f0764b77801982bb"),
        "darwin_arm64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/dc1fdcfd3f5b9d29cb1ebdf15e6e845bef9b0cc1/wasm-binaries-arm64.tbz2", "fca4eaf8ff528bb9308e5e8d0cf2709713b99fc19d55c6578a6c8f3e66182f55"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/dc1fdcfd3f5b9d29cb1ebdf15e6e845bef9b0cc1/wasm-binaries.tbz2", "151d7afdfb728e1e55ed1d100e4d3fbd20925fd65f3c3b9e093061a2c89dcac7"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/dc1fdcfd3f5b9d29cb1ebdf15e6e845bef9b0cc1/wasm-binaries.zip", "3001101622d98b2af3e5209154f60bbe341d32f6178307c6c723e84b5fe08bdc"),
    },
    "3.1.1": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/5ee64de9809592480da01372880ea11debd6c740/wasm-binaries.tbz2", "8b5f8cec55af0e6816a08d8d1e8b873f96d0e0504fdd6e8deb2fc024957d1aa7"),
        "darwin_arm64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/5ee64de9809592480da01372880ea11debd6c740/wasm-binaries-arm64.tbz2", "cb4caa48e7a310ecc5bdb5aa63222914ac2bc71e514cd7f0f365d00c3b10137b"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/5ee64de9809592480da01372880ea11debd6c740/wasm-binaries.tbz2", "ba94c5ecabacbedc89665a742c37c4c132c739aea46aa66fd744cb72b260c870"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/5ee64de9809592480da01372880ea11debd6c740/wasm-binaries.zip", "6cbe976aff6155cf1c48707f0520b5aa6a7770860e9b1964bfca3e5923ce7225"),
    },
    "3.1.0": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/562e3a0af169e6dea5e6dbecac2255d67c2c8b94/wasm-binaries.tbz2", "f6c1cad729ed799e1df09eacf5aa80cce9861d69ec6d9581c17e4ba8d9b064ce"),
        "darwin_arm64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/562e3a0af169e6dea5e6dbecac2255d67c2c8b94/wasm-binaries-arm64.tbz2", "1788d198be8f2416c314ca950e2042ff8f200fb1886b1a7f8ab9f5bccd618a3c"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/562e3a0af169e6dea5e6dbecac2255d67c2c8b94/wasm-binaries.tbz2", "0714344e32e244e6d44d9ea75937633ab1338e417a232fb66d6dcd7d4b704e8c"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/562e3a0af169e6dea5e6dbecac2255d67c2c8b94/wasm-binaries.zip", "756c41cbcab4ae6077cca30834d16151392b8c19ab186c13d42d7d05d6d727cc"),
    },
    "3.0.1": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.tbz2", "52ec2204115b727cc4de38b5eeae147eead12b299b98e5a88653d12958cae4d4"),
        "darwin_arm64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries-arm64.tbz2", "d866900ed0a0aa58729fd2eb97f2903b351bfd62c79334bde9285c10ce9feacc"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.tbz2", "25fd430268596229c4ac38e188d7c2b31f75c2ec8172b1351d763e37c830c6af"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/91b7a67a486d2430e73423a38d950d8a550826ed/wasm-binaries.zip", "0e072736b471c9a07cdf534ba4da46b3b6545b63c8a6cbb0ef7d544251e15092"),
    },
    "3.0.0": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.tbz2", "ebb17bc91c6a72ca06d17337d27aa1a2be4c9af4c68644c221712123f663b8ab"),
        "darwin_arm64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries-arm64.tbz2", "833611c8bd6f0978d6941883a8bbe4230f6b440e1870c1c2616f9dbd3bfae084"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.tbz2", "10646b64daea15354f14f89f7e79937f420b77f31bda7c4b174de2474835950f"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/7fbe748230f2ce99abbf975d9ad997699efb3153/wasm-binaries.zip", "0d4f2ff5d88a8eef5ed769ee4ffc5d5574143911d2e0079325cdc5206c9e9bb1"),
    },
    "2.0.34": {
        "darwin_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.tbz2", "975ae11000100362baf19d161fec04d82e1f7c9fb7d43c43864ddd65a47f1780"),
        "darwin_arm64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/mac/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries-arm64.tbz2", "d20afbf5a5ed9290c4387478f91b4f2d6cd4afa62de6529d5bd7657d38b975ee"),
        "linux_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/linux/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.tbz2", "a6304e3a52c172eb178c6f9817d74aa3ee411e97ef00bcae0884377799c49954"),
        "windows_amd64": ("https://storage.googleapis.com/webassembly/emscripten-releases-builds/win/d8fc1b92dbc0ce8d740a7adb937c5137ba4755e0/wasm-binaries.zip", "8167a44bb895a0fdc153836bed91bf387be57f2dc1b8f103bf70e68923b61d39"),
    },
}