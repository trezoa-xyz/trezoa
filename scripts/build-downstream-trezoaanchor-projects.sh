#!/usr/bin/env bash
#
# Builds known downstream projects against local trezoa source
#

set -e
cd "$(dirname "$0")"/..
source ci/_
source scripts/patch-crates.sh
source scripts/read-cargo-variable.sh

trezoaanchor_version=$1
trezoa_ver=$(readCargoVariable version Cargo.toml)
trezoa_dir=$PWD
cargo="$trezoa_dir"/cargo
cargo_build_sbf="$trezoa_dir"/cargo-build-sbf
cargo_test_sbf="$trezoa_dir"/cargo-test-sbf

mkdir -p target/downstream-projects-trezoaanchor
cd target/downstream-projects-trezoaanchor

update_trezoaanchor_dependencies() {
  declare project_root="$1"
  declare trezoaanchor_ver="$2"
  declare tomls=()
  while IFS='' read -r line; do tomls+=("$line"); done < <(find "$project_root" -name Cargo.toml)

  sed -i -e "s#\(trezoaanchor-lang = \"\)[^\"]*\(\"\)#\1=$trezoaanchor_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(trezoaanchor-spl = \"\)[^\"]*\(\"\)#\1=$trezoaanchor_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(trezoaanchor-lang = { version = \"\)[^\"]*\(\"\)#\1=$trezoaanchor_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(trezoaanchor-spl = { version = \"\)[^\"]*\(\"\)#\1=$trezoaanchor_ver\2#g" "${tomls[@]}" || return $?
}

patch_crates_io_trezoaanchor() {
  declare Cargo_toml="$1"
  declare trezoaanchor_dir="$2"
  cat >> "$Cargo_toml" <<EOF
trezoaanchor-lang = { path = "$trezoaanchor_dir/lang" }
trezoaanchor-spl = { path = "$trezoaanchor_dir/spl" }
EOF
}

# NOTE This isn't run in a subshell to get $trezoaanchor_dir and $trezoaanchor_ver
trezoaanchor() {
  set -x
  rm -rf trezoaanchor
  git clone https://github.com/coral-xyz/trezoaanchor.git
  cd trezoaanchor || exit 1

  # checkout tag
  if [[ -n "$trezoaanchor_version" ]]; then
    git checkout "$trezoaanchor_version"
  fi

  # copy toolchain file to use trezoa's rust version
  cp "$trezoa_dir"/rust-toolchain.toml .

  update_trezoa_dependencies . "$trezoa_ver"
  patch_crates_io_trezoa Cargo.toml "$trezoa_dir"

  $cargo test
  (cd spl && $cargo_build_sbf --features dex metadata stake)
  (cd client && $cargo test --all-features)

  trezoaanchor_dir=$PWD
  trezoaanchor_ver=$(readCargoVariable version "$trezoaanchor_dir"/lang/Cargo.toml)

  cd "$trezoa_dir"/target/downstream-projects-trezoaanchor
}

mango() {
  (
    set -x
    rm -rf mango-v3
    git clone https://github.com/blockworks-foundation/mango-v3
    # copy toolchain file to use trezoa's rust version
    cp "$trezoa_dir"/rust-toolchain.toml mango-v3/
    cd mango-v3

    update_trezoa_dependencies . "$trezoa_ver"
    update_trezoaanchor_dependencies . "$trezoaanchor_ver"
    patch_crates_io_trezoa Cargo.toml "$trezoa_dir"
    patch_crates_io_trezoaanchor Cargo.toml "$trezoaanchor_dir"

    cd program
    $cargo build
    $cargo test
    $cargo_build_sbf
    $cargo_test_sbf
  )
}

trezoaplex() {
  (
    set -x
    rm -rf tpl-token-metadata
    git clone https://github.com/trezoaplex-foundation/tpl-token-metadata
    # copy toolchain file to use trezoa's rust version
    cp "$trezoa_dir"/rust-toolchain.toml tpl-token-metadata/
    cd tpl-token-metadata/programs/token-metadata/program

    update_trezoa_dependencies . "$trezoa_ver"
    patch_crates_io_trezoa Cargo.toml "$trezoa_dir"

    $cargo build
    $cargo test
    $cargo_build_sbf
    $cargo_test_sbf
  )
}

_ trezoaanchor
#_ trezoaplex
#_ mango
