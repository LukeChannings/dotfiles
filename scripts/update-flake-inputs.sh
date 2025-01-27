#! /usr/bin/env nix-shell
#! nix-shell -i bash --packages curl jq

set -x

NIXPKGS_STATUS="$(curl -s "https://prometheus.nixos.org/api/v1/query?query=channel_revision")"

NIXPKGS_REV="$(echo "$NIXPKGS_STATUS" | jq -r '.data.result[] | select(.metric.channel == "nixpkgs-unstable") | .metric.revision')"
NIXPKGS_STABLE_REV="$(echo "$NIXPKGS_STATUS" | jq -r '.data.result[] | select(.metric.channel == "nixos-24.11") | .metric.revision')"

nix flake update \
  --override-input nixpkgs "github:NixOS/nixpkgs/${NIXPKGS_REV}" \
  --override-input nixpkgs-stable "github:NixOS/nixpkgs/${NIXPKGS_STABLE_REV}"
