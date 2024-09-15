{
  inputs,
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

    gc.automatic = true;

    linux-builder = {
      enable = true;

      # nixpkgs-unstable often does not have a cached linux-builder,
      # and we can't compile this ourselves without... a functioning linux-builder.
      # I'm pinning to a stable nixpkgs, where the package should always be cached.
      package = inputs.nixpkgs-darwin.legacyPackages.${pkgs.system}.darwin.linux-builder;

      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 80 * 1024;
            memorySize = 24 * 1024;
          };
          cores = 6;
        };
      };
    };
  };
}
