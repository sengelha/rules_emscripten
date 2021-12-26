<!-- omit in toc -->
# rules_emscripten

Bazel rules for building C/C++ code into Javascript using the
Emscripten toolset.

## Build Status

![Build Status](https://github.com/sengelha/rules_emscripten/actions/workflows/ci.yml/badge.svg)

<!-- omit in toc -->
## Table of Contents

- [Build Status](#build-status)
- [Quick Start Guide](#quick-start-guide)
- [Repository Rules](#repository-rules)
  - [emscripten_setup](#emscripten_setup)
    - [Attributes](#attributes)
- [Build Rules](#build-rules)
  - [emcc_binary](#emcc_binary)
    - [Attributes](#attributes-1)
  - [emcc_module](#emcc_module)
    - [Attributes](#attributes-2)

## Quick Start Guide

Add the following stanza to `WORKSPACE`:

```python
git_repository(
    name = "rules_emscripten",
    remote = "https://github.com/sengelha/rules_emscripten.git",
    branch = "master"
)

load("@rules_emscripten//emscripten:deps.bzl", "emscripten_rules_dependencies", "emscripten_setup")
emscripten_rules_dependencies()
emscripten_setup()
```

Add the following stanza to `BUILD`, adjusting as needed:

```python
load("@rules_emscripten//emscripten:def.bzl", "emcc_binary")

emcc_binary(
    name = "hello_world",
    srcs = ["main.cpp"],
)
```

For more examples, see [examples](examples).

## Repository Rules

### emscripten_setup

Setup up `rules_emscripten`, including registering appropriate toolchains.

```python
emscripten_setup(version)
```

#### Attributes

| Attribute Name | Type     | Required?  | Description                                                                                                                                                 |
| -------------- | -------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `version`      | `String` | `optional` | The version of Emscripten to use.  Set to `host` to use the emscripten SDK installed on the host machine.  Defaults to the latest supported Emscripten SDK. |

## Build Rules

### emcc_binary

Compiles a set of C/C++ files into a JavaScript "binary" (a .js and a .wasm
file) and allows it be executed via `bazel run`.

#### Attributes

| Attribute Name  | Type             | Required?  | Description                                                                                                                  |
| --------------- | ---------------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `name`          | `Name`           | `required` | A unique name for this rule.                                                                                                 |
| `srcs`          | `List of files`  | `required` | A list of source files required to compile the binary.                                                                       |
| `deps`          | `List of labels` | `optional` | The dependencies of this rule.                                                                                               |
| `configuration` | `String`         | `optional` | The build configuration for the target (`dbg`, `opt`, or `fastbuild`).  If not specified, uses the global `-c` option value. |

### emcc_module

Compiles a set of C/C++ files into a JavaScript module (a .js and a .wasm
file).

#### Attributes

| Attribute Name | Type             | Required?  | Description                                            |
| -------------- | ---------------- | ---------- | ------------------------------------------------------ |
| `name`         | `Name`           | `required` | A unique name for this rule.                           |
| `srcs`         | `List of files`  | `required` | A list of source files required to compile the module. |
| `deps`         | `List of labels` | `optional` | The dependencies of this rule.                         |
| `configuration` | `String`         | `optional` | The build configuration for the target (`dbg`, `opt`, or `fastbuild`).  If not specified, uses the global `-c` option value. |
