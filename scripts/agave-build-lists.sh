#!/usr/bin/env bash
# Defines reusable lists of Trezoa-team binary names for use across scripts.

# Source this file to access the arrays
# Example:
#   source "scripts/trezoa-build-lists.sh"
#   printf '%s\n' "${TREZOA_BINS_DEV[@]}"


# Groups with binary names to be built, based on their intended audience
# Keep names in sync with build/install scripts that consume these lists.

# shellcheck disable=SC2034
TREZOA_BINS_DEV=(
  cargo-build-sbf
  cargo-test-sbf
  trezoa-test-validator
)

TREZOA_BINS_END_USER=(
  trezoa-install
  trezoa
  trezoa-keygen
)

TREZOA_BINS_VAL_OP=(
  trezoa-validator
  trezoa-watchtower
  trezoa-gossip
  trezoa-genesis
  trezoa-faucet
)

TREZOA_BINS_DCOU=(
  trezoa-ledger-tool
  trezoa-bench-tps
)

# These bins are deprecated and will be removed in a future release
TREZOA_BINS_DEPRECATED=(
  trezoa-stake-accounts
  trezoa-tokens
  trezoa-install-init
)

DCOU_TAINTED_PACKAGES=(
  trezoa-ledger-tool
  trezoa-store-histogram
  trezoa-store-tool
  trezoa-accounts-cluster-bench
  trezoa-banking-bench
  trezoa-bench-tps
  trezoa-dos
  trezoa-local-cluster
  trezoa-transaction-dos
  trezoa-vortexor
)
