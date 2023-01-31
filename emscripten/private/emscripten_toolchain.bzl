load("//emscripten/private:platforms.bzl", "PLATFORMS")
load("//emscripten/private:providers.bzl", "EmscriptenSDK")
load("//emscripten/private/actions:compile.bzl", "compile")
load("//emscripten/private/actions:link.bzl", "link")

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
            compile = compile,
            link = link,
        ),
        sdk = sdk,
        # Internal fields -- may be read by emit functions.
        _builder = ctx.executable.builder,
        _launcher = ctx.executable.launcher,
    )]

emscripten_toolchain = rule(
    _impl,
    attrs = {
        # Minimum requirements to specify a toolchain
        "builder": attr.label(
            mandatory = True,
            cfg = "exec",
            executable = True,
            doc = "Tool used to execute most emscripten actions",
        ),
        "launcher": attr.label(
            mandatory = True,
            cfg = "exec",
            executable = True,
            doc = "Tool used to launch build binaries",
        ),
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

def declare_toolchains(host, sdk, builder, launcher):
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
            builder = builder,
            launcher = launcher,
            tags = ["manual"],
            visibility = ["//visibility:public"],
        )
        native.toolchain(
            name = toolchain_name,
            toolchain_type = "@com_stevenengelhardt_rules_emscripten//emscripten:toolchain",
            exec_compatible_with = [
                "@com_stevenengelhardt_rules_emscripten//emscripten/toolchain:" + host_emos,
                "@com_stevenengelhardt_rules_emscripten//emscripten/toolchain:" + host_emarch,
            ],
            target_compatible_with = p.constraints,
            toolchain = ":" + impl_name,
        )

def generate_toolchain_names():
    # keep in sync with declare_toolchains
    return ["emscripten_" + p.name for p in PLATFORMS]

def register_toolchains(repo):
    labels = [
        "@{}//:{}".format(repo, name)
        for name in generate_toolchain_names()
    ]
    native.register_toolchains(*labels)
