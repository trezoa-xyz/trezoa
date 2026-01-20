#!/usr/bin/env bash
#
# Fetches the latest TPL programs and produces the trezoa-genesis command-line
# arguments needed to install them
#

set -e

upgradeableLoader=BPFLoaderUpgradeab1e11111111111111111111111

fetch_program() {
  declare name=$1
  declare version=$2
  declare address=$3
  declare loader=$4

  declare so=spl_$name-$version.so

  if [[ $loader == "$upgradeableLoader" ]]; then
    genesis_args+=(--upgradeable-program "$address" "$loader" "$so" none)
  else
    genesis_args+=(--bpf-program "$address" "$loader" "$so")
  fi

  if [[ -r $so ]]; then
    return
  fi

  if [[ -r ~/.cache/trezoa-tpl/$so ]]; then
    cp ~/.cache/trezoa-tpl/"$so" "$so"
  else
    echo "Downloading $name $version"
    so_name="spl_${name//-/_}.so"
    (
      set -x
      curl -L --retry 5 --retry-delay 2 --retry-connrefused \
        -o "$so" \
        "https://github.com/trezoa-team/trezoa-program-library/releases/download/$name-v$version/$so_name"
    )

    mkdir -p ~/.cache/trezoa-tpl
    cp "$so" ~/.cache/trezoa-tpl/"$so"
  fi

}

fetch_program token 3.5.0 F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4 BPFLoader2111111111111111111111111111111111
fetch_program token-2022 0.9.0 8uWs1JBXDgzb1EbBKwyZ6JFuRpzdAqBTN1dZYfaJMEpu BPFLoaderUpgradeab1e11111111111111111111111
fetch_program memo  1.0.0 84XECa2ahfkNNYBj21kgvVs9BfqtvsFgUKSsbjpVEzGe BPFLoader1111111111111111111111111111111111
fetch_program memo  3.0.0 EMrTTTcZSoFKfgqy4rTQPxRg24w7dVGfRNyMM7DRDxvM BPFLoader2111111111111111111111111111111111
fetch_program associated-token-account 1.1.2 43tZW5Ak5GjbHt3YBU2rUyaWpZJPLZcXFcJuP8GNfscv BPFLoader2111111111111111111111111111111111
fetch_program feature-proposal 1.0.0 Feat1YXHhH6t1juaWF74WLcfv4XoNocjXA6sPWHNgAse BPFLoader2111111111111111111111111111111111

echo "${genesis_args[@]}" > tpl-genesis-args.sh

echo
echo "Available TPL programs:"
ls -l spl_*.so

echo
echo "trezoa-genesis command-line arguments (tpl-genesis-args.sh):"
cat tpl-genesis-args.sh
