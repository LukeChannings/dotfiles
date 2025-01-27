{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  services.nix-daemon.enable = true;

  nix = {
    package = lib.mkDefault pkgs.lix;
    channel.enable = false;
    settings = (import ./config.nix { users = config.users.users; });
  };
}
