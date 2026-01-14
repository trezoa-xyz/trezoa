# |source| this file
#
# Common utilities shared by other scripts in this directory
#
# The following directive disable complaints about unused variables in this
# file:
# shellcheck disable=2034
#

here="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. || exit 1; pwd)"
# shellcheck source=net/common.sh
source "$here"/net/common.sh

prebuild=
if [[ $1 = "--prebuild" ]]; then
  prebuild=true
fi

if [[ -n $USE_INSTALL || ! -f "$TREZOA_ROOT"/Cargo.toml ]]; then
  trezoa_program() {
    declare program="$1"
    if [[ -z $program ]]; then
      printf "trezoa"
    else
      if [[ $program == "validator" || $program == "ledger-tool" || $program == "watchtower" || $program == "install" ]]; then
        printf "trezoa-%s" "$program"
      else
        printf "trezoa-%s" "$program"
      fi
    fi
  }
else
  trezoa_program() {
    declare program="$1"
    declare crate="$program"
    declare manifest_path
    if [[ $program == "bench-tps" || $program == "ledger-tool" ]]; then
      manifest_path="--manifest-path $here/dev-bins/Cargo.toml"
    fi
    if [[ -z $program ]]; then
      crate="cli"
      program="trezoa"
    elif [[ $program == "validator" || $program == "ledger-tool" || $program == "watchtower" || $program == "install" ]]; then
      program="trezoa-$program"
    else
      program="trezoa-$program"
    fi

    if [[ -n $CARGO_BUILD_PROFILE ]]; then
      profile_arg="--profile $CARGO_BUILD_PROFILE"
    fi

    # Prebuild binaries so that CI sanity check timeout doesn't include build time
    if [[ $prebuild ]]; then
      (
        set -x
        # shellcheck disable=SC2086 # Don't want to double quote
        cargo $CARGO_TOOLCHAIN build $manifest_path $profile_arg --bin $program
      )
    fi

    printf "cargo $CARGO_TOOLCHAIN run $manifest_path $profile_arg --bin %s %s -- " "$program"
  }
fi

trezoa_bench_tps=$(trezoa_program bench-tps)
trezoa_faucet=$(trezoa_program faucet)
trezoa_validator=$(trezoa_program validator)
trezoa_genesis=$(trezoa_program genesis)
trezoa_gossip=$(trezoa_program gossip)
trezoa_keygen=$(trezoa_program keygen)
trezoa_ledger_tool=$(trezoa_program ledger-tool)
trezoa_cli=$(trezoa_program)

export RUST_BACKTRACE=1

default_arg() {
  declare name=$1
  declare value=$2

  for arg in "${args[@]}"; do
    if [[ $arg = "$name" ]]; then
      return
    fi
  done

  if [[ -n $value ]]; then
    args+=("$name" "$value")
  else
    args+=("$name")
  fi
}

replace_arg() {
  declare name=$1
  declare value=$2

  default_arg "$name" "$value"

  declare index=0
  for arg in "${args[@]}"; do
    index=$((index + 1))
    if [[ $arg = "$name" ]]; then
      args[$index]="$value"
    fi
  done
}
