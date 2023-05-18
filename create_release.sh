#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename $0) <version>"
  echo "Example: $(basename $0) 1.5.1"
  exit 1
fi

if [[ -z ${BUILD_WORKSPACE_DIRECTORY+x} ]]; then
  echo "ERROR: BUILD_WORKSPACE_DIRECTORY environment variable is not set"
  exit 1
fi

RELEASE_VERSION=$1
GIT_TAG=v$RELEASE_VERSION

case $(uname -s)-$(uname -m) in
Darwin-arm64) GIT_CHGLOG=$(realpath ./external/git_chglog_darwin_arm64/git-chglog);;
Linux-amd64)  GIT_CHGLOG=$(realpath ./external/git_chglog_linux_amd64/git-chglog);;
*)            echo "ERROR: Unhandled operating system/CPU combination $(uname -s)-$(uname -m)" 1>&2; exit 1;;
esac
if [[ ! -x $GIT_CHGLOG ]]; then
    echo "$GIT_CHGLOG is not executable" 1>&2
    exit 1
fi

cd $BUILD_WORKSPACE_DIRECTORY

if git tag -l | grep -q $GIT_TAG; then
    echo "ERROR: Tag $GIT_TAG already exists locally" >&2
    exit 1
fi

if git ls-remote --tags origin | grep -q $GIT_TAG; then
    echo "ERROR: Tag $GIT_TAG already exists on origin" >&2
    exit 1
fi

echo "Updating local tags..."
git pull --tags

echo "Generating CHANGELOG.md..."
$GIT_CHGLOG --tag-filter-pattern "v.*" --next-tag $GIT_TAG -o CHANGELOG.md
git add CHANGELOG.md
git commit -m "Update CHANGELOG for release $RELEASE_VERSION"

echo "Tagging source control with tag $GIT_TAG..."
git tag -a "$GIT_TAG" -m "Release $RELEASE_VERSION"

echo "Pushing all changes to origin..."
git push origin
git push origin "$GIT_TAG"