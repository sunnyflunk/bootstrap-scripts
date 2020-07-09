#!/bin/true

# Common functionality between all stages


# Emit a watning to tty
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

# Tightly control the path
export PATH="/usr/bin:/bin/:/sbin:/usr/sbin"

# Make sure he scripts are properly implemented.
[ ! -z "${SERPENT_STAGE_NAME}" ] || serpentFail "Stage name is not set"

export SERPENT_ROOT_DIR="$(dirname $(realpath -s $0))"
export SERPENT_BUILD_ROOT="${SERPENT_ROOT_DIR}/build"
export SERPENT_DOWNLOAD_DIR="${SERPENT_ROOT_DIR}/downloads"
export SERPENT_INSTALL_ROOT="${SERPENT_ROOT_DIR}/install"
export SERPENT_SOURCES_DIR="${SERPENT_ROOT_DIR}/sources"

# Stage specific directories
export SERPENT_BUILD_DIR="${SERPENT_BUILD_ROOT}/${SERPENT_STAGE_NAME}"
export SERPENT_INSTALL_DIR="${SERPENT_INSTALL_ROOT}/${SERPENT_STAGE_NAME}"
