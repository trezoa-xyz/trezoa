#!/usr/bin/env bash
#
# Creates update_manifest_keypair.json based on the current platform and
# environment
#
set -e
TREZOA_ROOT="$(cd "$(dirname "$0")"/..; pwd)"

source "$TREZOA_ROOT"/scripts/generate-target-triple.sh
TARGET="$BUILD_TARGET_TRIPLE"

TREZOA_INSTALL_UPDATE_MANIFEST_KEYPAIR="TREZOA_INSTALL_UPDATE_MANIFEST_KEYPAIR_${TARGET//-/_}"

# shellcheck disable=2154 # is referenced but not assigned
if [[ -z ${!TREZOA_INSTALL_UPDATE_MANIFEST_KEYPAIR} ]]; then
  echo "$TREZOA_INSTALL_UPDATE_MANIFEST_KEYPAIR not defined"
  exit 1
fi

echo "${!TREZOA_INSTALL_UPDATE_MANIFEST_KEYPAIR}" > update_manifest_keypair.json
ls -l update_manifest_keypair.json
