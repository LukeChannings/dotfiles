{
  pkgs,
  lib,
  config,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];

    registry.nixpkgs.to = {
      type = "path";
      path = lib.mkForce (builtins.toString pkgs.path);
    };

    settings = (import ./config.nix { users = config.users.users; });
  };
}
