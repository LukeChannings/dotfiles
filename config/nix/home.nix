{
  inputs,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  nix.package = lib.mkDefault pkgs.lix;
  programs.nix-index-database.comma.enable = true;
}
