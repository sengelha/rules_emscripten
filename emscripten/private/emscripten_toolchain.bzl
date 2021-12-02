load("//emscripten/private:platforms.bzl", "PLATFORMS")
load("//emscripten/private:providers.bzl", "EmscriptenSDK")
load("//emscripten/private/actions:binary.bzl", "emit_binary")
load("//emscripten/private/actions:module.bzl", "emit_module")

def _impl(ctx):
    sdk = ctx.attr.sdk[EmscriptenSDK]
    cross_compile = ctx.attr.emos != sdk.emos or ctx.attr.emarch != sdk.emarch
    return [platform_common.ToolchainInfo(
        # Public fields
        name = ctx.label.name,
        cross_compile = cross_compile,
        default_emos = ctx.attr.emos,
        default_emarch = ctx.attr.emarch,
        actions = struct(
            binary = emit_binary,
            module = emit_module,
        ),
        sdk = sdk,
    )]

emscripten_toolchain = rule(
    _impl,
    attrs = {
        # Minimum requirements to specify a toolchain
        "emos": attr.string(
            mandatory = True,
            doc = "Default target OS",
        ),
        "emarch": attr.string(
            mandatory = True,
            doc = "Default target architecture",
        ),
        "sdk": attr.label(
            mandatory = True,
            providers = [EmscriptenSDK],
            cfg = "exec",
            doc = "The SDK this toolchain is based on",
        ),
    },
    doc = "Defines an Emscripten toolchain based on an SDK",
    provides = [platform_common.ToolchainInfo],
)

def declare_toolchains(host, sdk):
    # keep in sync with generate_toolchain_names
    host_emos, _, host_emarch = host.partition("_")
    for p in PLATFORMS:
        toolchain_name = "emscripten_" + p.name
        impl_name = toolchain_name + "-impl"
        emscripten_toolchain(
            name = impl_name,
            emos = p.emos,
            emarch = p.emarch,
            sdk = sdk,
            tags = ["manual"],
            visibility = ["//visibility:public"],
        )
        native.toolchain(
            name = toolchain_name,
            toolchain_type = "@rules_emscripten//emscripten:toolchain",
            exec_compatible_with = [
                "@rules_emscripten//emscripten/toolchain:" + host_emos,
                "@rules_emscripten//emscripten/toolchain:" + host_emarch,
            ],
            target_compatible_with = p.constraints,
            toolchain = ":" + impl_name,
        )