BAZEL_EMOS_CONSTRAINTS = {
    "android": "@platforms//os:android",
    "darwin": "@platforms//os:osx",
    "freebsd": "@platforms//os:freebsd",
    "ios": "@platforms//os:ios",
    "linux": "@platforms//os:linux",
    "windows": "@platforms//os:windows",
}

BAZEL_EMARCH_CONSTRAINTS = {
    "386": "@platforms//cpu:x86_32",
    "amd64": "@platforms//cpu:x86_64",
    "arm": "@platforms//cpu:arm",
    "arm64": "@platforms//cpu:aarch64",
    "ppc64le": "@platforms//cpu:ppc",
    "s390x": "@platforms//cpu:s390x",
}

EMOS_EMARCH = (
    ("aix", "ppc64"),
    ("android", "386"),
    ("android", "amd64"),
    ("android", "arm"),
    ("android", "arm64"),
    ("darwin", "386"),
    ("darwin", "amd64"),
    ("darwin", "arm"),
    ("darwin", "arm64"),
    ("dragonfly", "amd64"),
    ("freebsd", "386"),
    ("freebsd", "amd64"),
    ("freebsd", "arm"),
    ("freebsd", "arm64"),
    ("illumos", "amd64"),
    ("ios", "amd64"),
    ("ios", "arm64"),
    ("js", "wasm"),
    ("linux", "386"),
    ("linux", "amd64"),
    ("linux", "arm"),
    ("linux", "arm64"),
    ("linux", "mips"),
    ("linux", "mips64"),
    ("linux", "mips64le"),
    ("linux", "mipsle"),
    ("linux", "ppc64"),
    ("linux", "ppc64le"),
    ("linux", "riscv64"),
    ("linux", "s390x"),
    ("nacl", "386"),
    ("nacl", "amd64p32"),
    ("nacl", "arm"),
    ("netbsd", "386"),
    ("netbsd", "amd64"),
    ("netbsd", "arm"),
    ("netbsd", "arm64"),
    ("openbsd", "386"),
    ("openbsd", "amd64"),
    ("openbsd", "arm"),
    ("openbsd", "arm64"),
    ("plan9", "386"),
    ("plan9", "amd64"),
    ("plan9", "arm"),
    ("solaris", "amd64"),
    ("windows", "386"),
    ("windows", "amd64"),
    ("windows", "arm"),
)

def _generate_constraints(names, bazel_constraints):
    return {
        name: bazel_constraints.get(name, "@com_stevenengelhardt_rules_emscripten//emscripten/toolchain:" + name)
        for name in names
    }

EMOS_CONSTRAINTS = _generate_constraints([p[0] for p in EMOS_EMARCH], BAZEL_EMOS_CONSTRAINTS)
EMARCH_CONSTRAINTS = _generate_constraints([p[1] for p in EMOS_EMARCH], BAZEL_EMARCH_CONSTRAINTS)

def _generate_platforms():
    platforms = []
    for emos, emarch in EMOS_EMARCH:
        constraints = [
            EMOS_CONSTRAINTS[emos],
            EMARCH_CONSTRAINTS[emarch],
        ]
        platforms.append(struct(
            name = emos + "_" + emarch,
            emos = emos,
            emarch = emarch,
            constraints = constraints,
        ))
    return platforms

PLATFORMS = _generate_platforms()

def generate_toolchain_names():
    # keep in sync with declare_toolchains
    return ["emscripten_" + p.name for p in PLATFORMS]