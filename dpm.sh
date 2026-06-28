

#get latest version number
VERSION="$(curl -sS "https://get.digitalasset.com/install/latest")"
echo "Installing dpm version ${VERSION}..."


# set your architecture to either amd64 | arm64
ARCH="$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"
echo "Detected architecture: ${ARCH}"


# set your OS to either darwin or linux
OS="$(uname | tr '[:upper:]' '[:lower:]')"
echo "Detected OS: ${OS}"


#pull down appropriate tarball for your OS and architecture
readonly TARBALL="dpm-${VERSION}-${OS}-${ARCH}.tar.gz"
echo "tarball name: ${TARBALL}..."


# determine location of tarball to download
TARBALL_URL="https://get.digitalasset.com/install/dpm-sdk/${TARBALL}"
echo "tarball URL: ${TARBALL_URL}..."


# make tmpdir
TMPDIR="$(mktemp -d)"

# download tarball
echo "Downloading ${TARBALL} to ${TMPDIR}/${TARBALL}..."
curl -SLf "${TARBALL_URL}" --output "${TMPDIR}/${TARBALL}" --progress-bar "$@"
echo "Downloaded ${TARBALL} to ${TMPDIR}/${TARBALL}..."


# create directory to extract into
extracted="${TMPDIR}/extracted"
mkdir -p "${extracted}"

# untar to extracted directory
tar xzf "${TMPDIR}/${TARBALL}" -C "${extracted}" --strip-components 1

# bootstrap dpm
"${extracted}/bin/dpm" bootstrap "${extracted}"

# cleanup tmpdir
rm -rf "${TMPDIR}"


