#!/bin/true

# Common functionality between all stages


# Emit a warning to tty
function printWarning()
{
    echo -en '\e[1m\e[93m[WARNING]\e[0m '
    echo $*
}

# Emit an error to tty
function printError()
{
    echo -en '\e[1m\e[91m[ERROR]\e[0m '
    echo $*
}

# Emit info to tty
function printInfo()
{
    echo -en '\e[1m\e[94m[INFO]\e[0m '
    echo $*
}

# Failed to do a thing. Exit fatally.
function serpentFail()
{
    printError $*
    exit 1
}

function requireTools()
{
    for tool in $* ; do
        which "${tool}" &>/dev/null  || serpentFail "Missing host executable: ${tool}"
    done
}

# Helper to get older stage tree
function getInstallDir()
{
    [ ! -z "${1}" ] || serpentFail "Incorrect use of getInstallDir"
    echo "${SERPENT_INSTALL_ROOT}/${SERPENT_STAGE_NAME}"
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

    [ "${computeHash}" == "${sourceHash}" ] || serpentFail "Corrupt download: ${sourcePath}"
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
        return
    fi

    printInfo "Downloading ${sourcePathBase}"
    curl -L --output "${sourcePath}" "${sourceURL}"
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

# Tightly control the path
export PATH="/usr/bin:/bin/:/sbin:/usr/sbin"

# Make sure he scripts are properly implemented.
[ ! -z "${SERPENT_STAGE_NAME}" ] || serpentFail "Stage name is not set"

export SERPENT_ROOT_DIR="$(dirname $(realpath -s ${BASH_SOURCE[0]}))"
export SERPENT_BUILD_ROOT="${SERPENT_ROOT_DIR}/build"
export SERPENT_DOWNLOAD_DIR="${SERPENT_ROOT_DIR}/downloads"
export SERPENT_INSTALL_ROOT="${SERPENT_ROOT_DIR}/install"
export SERPENT_SOURCES_DIR="${SERPENT_ROOT_DIR}/sources"

# Stage specific directories
export SERPENT_BUILD_DIR="${SERPENT_BUILD_ROOT}/${SERPENT_STAGE_NAME}"
export SERPENT_INSTALL_DIR="${SERPENT_INSTALL_ROOT}/${SERPENT_STAGE_NAME}"

export SERPENT_BUILD_SCRIPT=$(basename "${0}")
export SERPENT_BUILD_NAME="${SERPENT_BUILD_SCRIPT%.sh}"

# Basic validation.
[ -d "${SERPENT_SOURCES_DIR}" ] || serpentFail "Missing source tree"

# Check basic requirements before we go anywhere.
requireTools curl tar
