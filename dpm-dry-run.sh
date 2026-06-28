#!/usr/bin/env bash
#
# Dry-run version of dpm.sh
# Performs every step for real (version lookup, download, extract, cleanup)
# EXCEPT it does not execute /bin/dpm -- that step is only echoed.

set -euo pipefail

echo "=== DRY RUN: discovery runs for real; download, extract, and dpm are only echoed ==="
echo

# get latest version number
VERSION="$(curl -sS "https://get.digitalasset.com/install/latest")"
echo "Installing dpm version ${VERSION}..."

# set your architecture to either amd64 | arm64
ARCH="$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"
echo "Detected architecture: ${ARCH}"

# set your OS to either darwin or linux
OS="$(uname | tr '[:upper:]' '[:lower:]')"
echo "Detected OS: ${OS}"

# pull down appropriate tarball for your OS and architecture
readonly TARBALL="dpm-${VERSION}-${OS}-${ARCH}.tar.gz"
echo "tarball name: ${TARBALL}..."

# determine location of tarball to download
TARBALL_URL="https://get.digitalasset.com/install/dpm-sdk/${TARBALL}"
echo "tarball URL: ${TARBALL_URL}..."

# make tmpdir
TMPDIR="$(mktemp -d)"
echo "Created tmpdir: ${TMPDIR}"

# download tarball  -- SKIPPED in dry-run, only echoed
echo "Downloading ${TARBALL} to ${TMPDIR}/${TARBALL}..."
echo "[dry-run] would run: curl -SLf \"${TARBALL_URL}\" --output \"${TMPDIR}/${TARBALL}\" --progress-bar $*"

# create directory to extract into
extracted="${TMPDIR}/extracted"
mkdir -p "${extracted}"
echo "Created extract dir: ${extracted}"

# untar to extracted directory  -- SKIPPED in dry-run (no tarball was downloaded), only echoed
echo "[dry-run] would run: tar xzf \"${TMPDIR}/${TARBALL}\" -C \"${extracted}\" --strip-components 1"

# bootstrap dpm  -- SKIPPED in dry-run, only echoed
echo "[dry-run] would run: \"${extracted}/bin/dpm\" bootstrap \"${extracted}\""

# cleanup tmpdir
rm -rf "${TMPDIR}"
echo "Removed tmpdir: ${TMPDIR}"

echo
echo "=== DRY RUN complete ==="
