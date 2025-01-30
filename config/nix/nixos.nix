{ inputs, ... }:
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];
}
