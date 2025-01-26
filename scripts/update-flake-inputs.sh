#! /usr/bin/env nix-shell
#! nix-shell -i bash --packages curl jq

set -x

NIXPKGS_REV="$( \
  curl -s "https://prometheus.nixos.org/api/v1/query?query=channel_revision" | \
  jq -r '.data.result[] | select(.metric.channel == "nixpkgs-unstable") | .metric.revision'\
)"

nix flake update --override-input nixpkgs "github:NixOS/nixpkgs/${NIXPKGS_REV}"
