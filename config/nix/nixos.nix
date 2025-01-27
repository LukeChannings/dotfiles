{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  nix.package = lib.mkDefault pkgs.lix;
  nix.channel.enable = false;
  nix.settings = (import ./config.nix { users = config.users.users; });
}
