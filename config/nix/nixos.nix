{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.lix;
  nix.channel.enable = false;
  nix.settings = (import ./config.nix { users = config.users.users; });
}
