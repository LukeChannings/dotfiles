# Luke's dotfiles

## Maintenance

### Keeping dependencies up-to-date

- `./scripts/update-flake-inputs.sh` – update inputs, using the latest nixpkgs Hydra build.
- `./scripts/diff-flake-lock.pl` – print updated inputs in the lockfile with github compare links

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
