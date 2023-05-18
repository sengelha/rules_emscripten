# Changelog

<a name="v1.7.0"></a>
## [v1.7.0](https://github.com/sengelha/rules_emscripten/compare/v1.6.0...v1.7.0) (2023-05-17)
### Bug Fixes

* Fix create_release.sh to work on OS X
* Support if python is actually python3
* Use python3 for running embuilder.py
* More Windows fixes
* Fix host SDK emcc invocations on Windows
* Fix em-config invocation on Windows
* Fix yaml GitHub Actions syntax
* Separate out bazel test on Windows into cmd
* Fix GitHub Actions bazel test //... failures on Windows
* Fix tests on Windows
* Fix Windows builds

### Code Refactoring

* Use ~/.cache/emscripten for emcc cache
* Remove bazel caching from CI workflow
* Remove windows from nightly builds
* Move build_bazel_rules_nodejs to internal dep
* Use embuilder EXE wrapper instead of calling Python script directly
* Warn emcc cache during workspace init
* Move tools to a struct inside the toolchain
* Add e2e tests, including host_sdk
* Cache Bazel build results between builds
* Rename is_windows attribute to private_is_windows
* Upgrade bazel to 5.3.2
* Move launcher templates into private/templates directory
* Upgrade build_bazel_rules_nodejs to 5.7.1
* Refactor internal deps to be like bazel's reference ruleset
* Rename release workflow
* Make ci builds linux-only.
* Add nightly builds
* Rename ruleset to com_stevenengelhardt_rules_emscripten
* Set bazelrc flags
* Upgrade bazel version to 5.3.1
* Upgrade bazel version to 5.2.0

### Documentation Updates

* Update README with latest rule documentation
* Add notes on supported platforms to README
* Include documentation updates in CHANGELOG generation

### New Features

* Add support for emcc 3.1.30
* Add support for emcc 3.1.1
* Add Mac-ARM64 support


<a name="v1.6.0"></a>
## [v1.6.0](https://github.com/sengelha/rules_emscripten/compare/v1.5.2...v1.6.0) (2022-01-08)
### Documentation Updates

* Update reference to rules_emscripten in README

### New Features

* Add Windows support


<a name="v1.5.2"></a>
## [v1.5.2](https://github.com/sengelha/rules_emscripten/compare/v1.5.1...v1.5.2) (2022-01-05)
### Bug Fixes

* Fix exclusion of files in release zip
* Fix tag name extraction during release process

### Code Refactoring

* Remove v from release archive name and .git folder
* Pull remote tags when performing release
* Change to use zip binary to create release archive
* Publish zip file when creating release
* Remove changelog updating from GitHub Actions workflow


<a name="v1.5.1"></a>
## [v1.5.1](https://github.com/sengelha/rules_emscripten/compare/v1.5.0...v1.5.1) (2022-01-05)
### Bug Fixes

* Remove invalid Bazel target
* Fix repository URL in changelog template
* Fix create_release script to push changes
* Fix name of git-chglog config directory

### New Features

* Add create_release script and Bazel task
* Add git-chglog config
* Automatically update CHANGELOG.md on release


<a name="v1.5.0"></a>
## [v1.5.0](https://github.com/sengelha/rules_emscripten/compare/v1.4.0...v1.5.0) (2022-01-05)
### Code Refactoring

* Only run builds on PRs and main branch

### New Features

* Add support for emsdk 3.1.0
* Add support for emsdk 3.0.1


<a name="v1.4.0"></a>
## [v1.4.0](https://github.com/sengelha/rules_emscripten/compare/v1.3.0...v1.4.0) (2022-01-05)
### Documentation Updates

* Fix link to build status

### New Features

* Support bazel build configurations


<a name="v1.3.0"></a>
## [v1.3.0](https://github.com/sengelha/rules_emscripten/compare/v1.2.0...v1.3.0) (2022-01-05)
### Code Refactoring

* Move binary and library to context
* Add check of node is in path

### New Features

* Support building on systems without node preinstalled


<a name="v1.2.0"></a>
## [v1.2.0](https://github.com/sengelha/rules_emscripten/compare/v1.1.0...v1.2.0) (2022-01-05)
### New Features

* Add support for pre-js and post-js


<a name="v1.1.0"></a>
## [v1.1.0](https://github.com/sengelha/rules_emscripten/compare/v1.0.0...v1.1.0) (2022-01-05)
### Bug Fixes

* Do not create .o from .hpp files

### Code Refactoring

* Redo tests using node.js and tape NPM module
* Mark emcc_binary rule as executable
* Rename examples/c_module to examples/module
* Separate compile and link stage

### Documentation Updates

* Remove version from setup in README
* Reorder README sections
* Add build status to README

### New Features

* Add embind example
* Support downloading emscripten SDK


<a name="v1.0.0"></a>
## v1.0.0 (2022-01-05)
### Bug Fixes

* Fix create release action

### Code Refactoring

* Add emscripten to CI pipeline
* Define emscripten toolchains and use from rules

### Documentation Updates

* Create README for ruleset

### New Features

* Add create release action on tag push
* Add .bazelversion file to lock down Bazel version
* Add GitHub actions workflow
* Inital commit

