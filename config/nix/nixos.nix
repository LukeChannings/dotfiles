{
  config,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nixVersions.latest;
  nix.channel.enable = false;
  nix.settings = (import ./config.nix { users = config.users.users; });
}
