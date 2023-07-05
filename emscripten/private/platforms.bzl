"Platform definitions for the emscripten toolchain."

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

def detect_host_platform(ctx):
    """Detects the host platform.153

    Args:
      ctx: A repository context

    Returns:
      A tuple of (operating system, architecture)"""
    if ctx.os.name == "linux":
        emos, emarch = "linux", "amd64"
        res = ctx.execute(["uname", "-p"])
        if res.return_code == 0:
            uname = res.stdout.strip()
            if uname == "s390x":
                emarch = "s390x"
            elif uname == "i686":
                emarch = "386"

        # uname -p is not working on Aarch64 boards
        # or for ppc64le on some distros
        res = ctx.execute(["uname", "-m"])
        if res.return_code == 0:
            uname = res.stdout.strip()
            if uname == "aarch64":
                emarch = "arm64"
            elif uname == "armv6l":
                emarch = "arm"
            elif uname == "armv7l":
                emarch = "arm"
            elif uname == "ppc64le":
                emarch = "ppc64le"

        # Default to amd64 when uname doesn't return a known value.

    elif ctx.os.name == "mac os x":
        emos, emarch = "darwin", "amd64"

        res = ctx.execute(["uname", "-m"])
        if res.return_code == 0:
            uname = res.stdout.strip()
            if uname == "arm64":
                emarch = "arm64"

        # Default to amd64 when uname doesn't return a known value.

    elif ctx.os.name.startswith("windows"):
        emos, emarch = "windows", "amd64"
    elif ctx.os.name == "freebsd":
        emos, emarch = "freebsd", "amd64"
    else:
        fail("Unsupported operating system: " + ctx.os.name)

    return emos, emarch

def is_windows(ctx):
    emos, _ = detect_host_platform(ctx)
    return emos == "windows"
