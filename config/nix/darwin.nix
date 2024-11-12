{
  pkgs,
  config,
  ...
}:
{
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixVersions.latest;
    channel.enable = false;
    settings = (import ./config.nix { users = config.users.users; });
  };
}
