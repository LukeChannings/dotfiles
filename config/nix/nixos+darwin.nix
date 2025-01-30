{
  pkgs,
  inputs,
  lib,
  ...
}:
with builtins;
let substituters = import ./substituters.nix;
in
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  nix.package = lib.mkDefault pkgs.lix;
  nix.channel.enable = false;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    accept-flake-config = false;

    warn-dirty = false;
    trusted-users = [ "luke@idm.channings.me" "luke" ];

    substituters = map (k: "https://${head (split "-1:" k)}") substituters;
    trusted-public-keys = substituters;

    max-substitution-jobs = 128;
    http-connections = 0;
  };
}
