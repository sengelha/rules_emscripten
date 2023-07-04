"Declares constraints for toolchains"

load(
    "@com_stevenengelhardt_rules_emscripten//emscripten/private:platforms.bzl",
    "EMARCH_CONSTRAINTS",
    "EMOS_CONSTRAINTS",
    "PLATFORMS",
)

def declare_constraints():
    """Generates constraint_values and platform targets for valid platforms.
    Each constraint_value corresponds to a valid emos or emarch.
    The emos and emarch values belong to the constraint_settings
    @platforms//os:os and @platforms//cpu:cpu, respectively.
    To avoid redundancy, if there is an equivalent value in @platforms,
    we define an alias here instead of another constraint_value.
    Each platform defined here selects a emos and emarch constraint value.
    These platforms may be used with --platforms for cross-compilation,
    though users may create their own platforms (and
    @bazel_tools//platforms:default_platform will be used most of the time).
    """
    for emos, constraint in EMOS_CONSTRAINTS.items():
        if constraint.startswith("@com_stevenengelhardt_rules_emscripten//emscripten/toolchain:"):
            native.constraint_value(
                name = emos,
                constraint_setting = "@platforms//os:os",
            )
        else:
            native.alias(
                name = emos,
                actual = constraint,
            )

    for emarch, constraint in EMARCH_CONSTRAINTS.items():
        if constraint.startswith("@com_stevenengelhardt_rules_emscripten//emscripten/toolchain:"):
            native.constraint_value(
                name = emarch,
                constraint_setting = "@platforms//cpu:cpu",
            )
        else:
            native.alias(
                name = emarch,
                actual = constraint,
            )

    for p in PLATFORMS:
        native.platform(
            name = p.name,
            constraint_values = p.constraints,
        )
