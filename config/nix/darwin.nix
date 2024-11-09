{
  pkgs,
  config,
  ...
}:
{
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = [ "nixpkgs=${pkgs.path}" ];

    registry.nixpkgs.to = {
      type = "path";
      path = builtins.toString pkgs.path;
    };

    settings = (import ./config.nix { users = config.users.users; });
  };
}
