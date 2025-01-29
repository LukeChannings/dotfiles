{ inputs, ... }: {
  imports = [
    inputs.nix-index-database.darwinModules.nix-index
  ];
}
