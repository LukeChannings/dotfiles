# Luke's dotfiles

## Maintenance

### Updating Nixpkgs

1. Find the latest successful [Hydra build](https://status.nixos.org) for a nixpkgs channel
2. Update the input to that revision
    - [With a workflow](https://github.com/LukeChannings/dotfiles/actions/workflows/update-inputs.yaml)
    - Or manually with `nix flake update --override-input nixpkgs github:NixOS/nixpkgs/<rev>`

### Switching between a local clone and the git repo

For flakes consuming this project it is useful to add a registry item for `dotfiles`

```sh
nix registry add flake:dotfiles github:LukeChannings/dotfiles
```

This project can then be used as in input like so:

```nix
{
  inputs.dotfiles.url = "dotfiles";
}
```

To switch to a local clone:

```bash
nix registry add flake:dotfiles path:$LOCAL_DOTFILES_PATH

cd $CONSUMING_REPO

nix flake update dotfiles
```
