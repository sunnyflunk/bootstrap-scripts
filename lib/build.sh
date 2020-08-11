#!/bin/true

# Build stages functionality
export SERPENT_ROOT_DIR="$(dirname $(dirname $(realpath -s ${BASH_SOURCE[0]})))"

. "${SERPENT_ROOT_DIR}/lib/base.sh"

# Make sure the scripts are properly implemented.
[ ! -z "${SERPENT_STAGE_NAME}" ] || serpentFail "Stage name is not set"

# Stage specific directories
export SERPENT_BUILD_DIR="${SERPENT_BUILD_ROOT}/${SERPENT_STAGE_NAME}"
export SERPENT_INSTALL_DIR="${SERPENT_INSTALL_ROOT}/${SERPENT_STAGE_NAME}"
export SERPENT_BUILD_SCRIPT=$(basename "${0}")
export SERPENT_BUILD_NAME="${SERPENT_BUILD_SCRIPT%.sh}"
export SERPENT_BUILD_JOBS=$(nproc)

# Helper to get older stage tree
function getInstallDir()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of getInstallDir"
    echo "${SERPENT_INSTALL_ROOT}/stage${1}"
}

# Verify the download is correct
function verifyDownload()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of verifyDownload"
    sourceFile="${SERPENT_SOURCES_DIR}/${1}"
    [ -f "${sourceFile}" ] || serpentFail "Missing source file: ${sourceFile}"
    sourceURL="$(cat ${sourceFile} | cut -d ' ' -f 1)"
    sourceHash="$(cat ${sourceFile} | cut -d ' ' -f 2)"
    [ ! -z "${sourceURL}" ] || serpentFail "Missing URL for source: $1"
    [ ! -z "${sourceHash}" ] || serpentFail "Missing hash for source: $1"
    sourcePathBase=$(basename "${sourceURL}")
    sourcePath="${SERPENT_DOWNLOAD_DIR}/${sourcePathBase}"

    printInfo "Computing hash for ${sourcePathBase}"

    computeHash=$(sha256sum "${sourcePath}" | cut -d ' ' -f 1)
    [ $? -eq 0 ] || serpentFail "Failed to compute SHA256sum"

    if [ "${computeHash}" != "${sourceHash}" ]; then
        rm -v "${sourcePath}"
        serpentFail "Corrupt download: ${sourcePath}\nExpected: ${sourceHash}\nFound: ${computeHash}"
    fi
}

# Download a file from sources/
function downloadSource()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of downloadSource"
    sourceFile="${SERPENT_SOURCES_DIR}/${1}"
    [ -f "${sourceFile}" ] || serpentFail "Missing source file: ${sourceFile}"
    sourceURL="$(cat ${sourceFile} | cut -d ' ' -f 1)"
    sourceHash="$(cat ${sourceFile} | cut -d ' ' -f 2)"
    [ ! -z "${sourceURL}" ] || serpentFail "Missing URL for source: $1"
    [ ! -z "${sourceHash}" ] || serpentFail "Missing hash for source: $1"
    sourcePathBase=$(basename "${sourceURL}")
    sourcePath="${SERPENT_DOWNLOAD_DIR}/${sourcePathBase}"

    mkdir -p "${SERPENT_DOWNLOAD_DIR}" || serpentFail "Failed to create download tree"

    if [[ -f "${sourcePath}" ]]; then
        printInfo "Skipping download of ${sourcePathBase}"
        verifyDownload "${1}"
        return
    fi

    if [[ -f "${sourcePath}.partial" ]]; then
        printInfo "Resuming download of ${sourcePathBase}"
        curl -C - -L --fail --ftp-pasv --retry 3 --retry-delay 5 -o "${sourcePath}.partial" "${sourceURL}"
        mv "${sourcePath}.partial" "${sourcePath}" || serpentFail "Failed to move completed resumed file"
        verifyDownload "${1}"
        return
    fi

    printInfo "Downloading ${sourcePathBase}"
    curl -C - -L --fail --ftp-pasv --retry 3 --retry-delay 5 -o "${sourcePath}.partial" "${sourceURL}"
    mv "${sourcePath}.partial" "${sourcePath}" || serpentFail "Failed to move completed downloaded file"
    verifyDownload "${1}"
}

# Extract a tarball into the current working directory
function extractSource()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of extractSource"
    sourceFile="${SERPENT_SOURCES_DIR}/${1}"
    [ -f "${sourceFile}" ] || serpentFail "Missing source file: ${sourceFile}"
    sourceURL="$(cat ${sourceFile} | cut -d ' ' -f 1)"
    [ ! -z "${sourceURL}" ] || serpentFail "Missing URL for source: $1"
    sourcePathBase=$(basename "${sourceURL}")
    sourcePath="${SERPENT_DOWNLOAD_DIR}/${sourcePathBase}"

    printInfo "Extracting ${sourcePathBase}"

    tar xf "${sourcePath}" -C . || serpentFail "Failed to extract ${sourcePath}"
}

# Prepare the build tree
function prepareBuild()
{
    export SERPENT_BUILD_DIR="${SERPENT_BUILD_DIR}/${SERPENT_BUILD_NAME}"
    printInfo "Building ${SERPENT_BUILD_NAME} in ${SERPENT_BUILD_DIR}"

    if [[ -d "${SERPENT_BUILD_DIR}" ]]; then
        printWarning "Removing stale build directory"
        rm -rf "${SERPENT_BUILD_DIR}" || serpentFail "Failed to remove stale build directory"
    fi

    mkdir -p "${SERPENT_BUILD_DIR}" || serpentFail "Cannot create working tree"
    cd "${SERPENT_BUILD_DIR}"
}

# Fetch all sources for all builds
function prefetchSources()
{
    printInfo "Prefetching all sources"

    for sourceFile in "${SERPENT_SOURCES_DIR}"/* ; do
        bnom=$(basename "${sourceFile}")
        downloadSource "${bnom}"
    done
}

# Enable ccache if possible
function enableCcache()
{
    if [[ -e "/usr/lib64/ccache/bin" ]]; then
        export PATH="/usr/lib64/ccache/bin:$PATH"
        printInfo "ccache enabled"
    elif [[ -e "/usr/lib/ccache/bin" ]]; then
        printInfo "ccache enabled"
        export PATH="/usr/lib/ccache/bin:$PATH"
    else
        printWarning "Failed to enable ccache"
    fi
}

# Basic validation.
[ -d "${SERPENT_SOURCES_DIR}" ] || serpentFail "Missing source tree"

# Check basic requirements before we go anywhere.
requireTools curl tar ninja cmake uname patch

# TODO: Revisit this if needed
export SERPENT_ARCH=`uname -m`

if [[ -e '/lib/ld-linux-x86-64.so.2' ]] || [[ -e '/lib64/ld-linux-x86-64.so.2' ]]; then
    export SERPENT_HOST="${SERPENT_ARCH}-linux-gnu"
else
    printError "Unsupported host configuration"
    exit 1
fi
    
export SERPENT_TARGET=${SERPENT_TARGET:-"ia"}

[ -e "${SERPENT_ROOT_DIR}/targets/${SERPENT_TARGET}.sh" ] || serpentFail "Failed to load targets/${SERPENT_TARGET}.sh"

unset CFLAGS
unset CXXFLAGS
unset LDFLAGS

printInfo "Using '${SERPENT_TARGET}' build configuration"
source "${SERPENT_ROOT_DIR}/targets/${SERPENT_TARGET}.sh"
