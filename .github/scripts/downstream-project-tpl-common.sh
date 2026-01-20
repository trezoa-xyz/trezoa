#!/usr/bin/env bash
set -e

here="$(dirname "${BASH_SOURCE[0]}")"

#shellcheck source=ci/downstream-projects/common.sh
source "$here"/../../ci/downstream-projects/common.sh

set -x
rm -rf tpl
git clone https://github.com/trezoa-xyz/trezoa-program-library.git tpl -b v1.18

# copy toolchain file to use trezoa's rust version
cp "$TREZOA_DIR"/rust-toolchain.toml tpl/
cd tpl || exit 1

project_used_trezoa_version=$(sed -nE 's/trezoa-sdk = \"[>=<~]*(.*)\"/\1/p' <"token/program/Cargo.toml")
echo "used trezoa version: $project_used_trezoa_version"
if semverGT "$project_used_trezoa_version" "$TREZOA_VER"; then
  echo "skip"
  export SKIP_TPL_DOWNSTREAM_PROJECT_TEST=1
  return
fi

./patch.crates-io.sh "$TREZOA_DIR"
# anza migration stopgap. can be removed when agave is fully recommended for public usage.
sed -i 's/trezoa-geyser-plugin-interface/agave-geyser-plugin-interface/g' ./Cargo.toml
