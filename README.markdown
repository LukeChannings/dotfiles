# Luke's dotfiles

## Maintenance

### Updating Nixpkgs

1. Find the latest successful [Hydra build](https://status.nixos.org) for a nixpkgs channel
2. Update the input to that revision
    - [With a workflow](https://github.com/LukeChannings/dotfiles/actions/workflows/update-inputs.yaml)
    - Or manually with `nix flake update --override-input nixpkgs github:NixOS/nixpkgs/<rev>`

