#!/usr/bin/env bash

set -euo pipefail

export PART_1_PACKAGES=(
  trezoa-ledger
)

export PART_2_PACKAGES=(
  trezoa-accounts-db
  trezoa-runtime
  trezoa-perf
  trezoa-core
  trezoa-wen-restart
  trezoa-gossip
)
