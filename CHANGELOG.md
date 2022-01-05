# Changelog

<a name="v1.5.1"></a>
## [v1.5.1](https://github.com/sengelha/rules_emscripten/compare/v1.5.0...v1.5.1) (2022-01-05)
### Bug Fixes

* Fix repository URL in changelog template
* Fix create_release script to push changes
* Fix name of git-chglog config directory

### New Features

* Add create_release script and Bazel task
* Add git-chglog config
* Automatically update CHANGELOG.md on release


<a name="v1.5.0"></a>
## [v1.5.0](https://github.com/sengelha/rules_emscripten/compare/v1.4.0...v1.5.0) (2022-01-05)
### Bug Fixes

* Do not create .o from .hpp files
* Fix create release action

### Code Refactoring

* Only run builds on PRs and main branch
* Move binary and library to context
* Add check of node is in path
* Redo tests using node.js and tape NPM module
* Mark emcc_binary rule as executable
* Rename examples/c_module to examples/module
* Separate compile and link stage
* Add emscripten to CI pipeline
* Define emscripten toolchains and use from rules

### New Features

* Add support for emsdk 3.1.0
* Add support for emsdk 3.0.1
* Support bazel build configurations
* Support building on systems without node preinstalled
* Add support for pre-js and post-js
* Add embind example
* Support downloading emscripten SDK
* Add create release action on tag push
* Add .bazelversion file to lock down Bazel version
* Add GitHub actions workflow
* Inital commit


<a name="v1.4.0"></a>
## [v1.4.0](https://github.com/sengelha/rules_emscripten/compare/v1.3.0...v1.4.0) (2021-12-26)
### New Features

* Support bazel build configurations


<a name="v1.3.0"></a>
## [v1.3.0](https://github.com/sengelha/rules_emscripten/compare/v1.2.0...v1.3.0) (2021-12-21)
### Code Refactoring

* Move binary and library to context
* Add check of node is in path

### New Features

* Support building on systems without node preinstalled


<a name="v1.2.0"></a>
## [v1.2.0](https://github.com/sengelha/rules_emscripten/compare/v1.1.0...v1.2.0) (2021-12-09)
### New Features

* Add support for pre-js and post-js


<a name="v1.1.0"></a>
## [v1.1.0](https://github.com/sengelha/rules_emscripten/compare/v1.0.0...v1.1.0) (2021-12-08)
### Bug Fixes

* Do not create .o from .hpp files

### Code Refactoring

* Redo tests using node.js and tape NPM module
* Mark emcc_binary rule as executable
* Rename examples/c_module to examples/module
* Separate compile and link stage

### New Features

* Add embind example
* Support downloading emscripten SDK


<a name="v1.0.0"></a>
## v1.0.0 (2021-12-02)
### Bug Fixes

* Fix create release action

### Code Refactoring

* Add emscripten to CI pipeline
* Define emscripten toolchains and use from rules

### New Features

* Add create release action on tag push
* Add .bazelversion file to lock down Bazel version
* Add GitHub actions workflow

