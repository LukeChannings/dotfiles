{
  pkgs,
  config,
  ...
}:
{
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixVersions.latest;
    settings = (import ./config.nix { users = config.users.users; });
  };
}
