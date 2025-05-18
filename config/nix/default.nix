{ ... }:
let
  substituters = [
    {
      url = "https://attic.svc.channings.me/nix?priority=10";
      key = "nix:CLpxkxK7MCT/RRXSU2EpfiQVoCLreSR6QiJGzHtcyYQ=";
    }
    {
      url = "https://cache.nixos.org?priority=40";
      key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    }
    {
      url = "https://nix-community.cachix.org?priority=50";
      key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
    {
      url = "https://devenv.cachix.org?priority=50";
      key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    }
    {
      url = "https://nixos-raspberrypi.cachix.org?priority=50";
      key = "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=";
    }
  ];
  nixSettingsModule =
    {
      lib,
      nixpkgs,
      nixpkgs-latest,
      ...
    }:
    {
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # It's tempting to enable this, but it's a massive security hole
        accept-flake-config = false;

        warn-dirty = false;

        trusted-users = [
          "@wheel"
          "@admin"
          "@nixbld"
        ];

        substituters = lib.mkForce (map (_: _.url) substituters);
        trusted-substituters = lib.mkForce (map (_: _.url) substituters);
        trusted-public-keys = lib.mkForce (map (_: _.key) substituters);

        max-substitution-jobs = 128;
        http-connections = 0;
        nix-path = [
          "nixpkgs=${nixpkgs}"
          "nixpkgs-latest=${nixpkgs-latest}"
        ];
      };
      nix.registry = {
        pkgs.flake = nixpkgs;
        nixpkgs.flake = nixpkgs;
        nixpkgs-latest.flake = nixpkgs-latest;
      };
    };
in
{
  flake = {
    darwinModules.nix = nixSettingsModule;
    nixosModules.nix = nixSettingsModule;
    homeModules.nix = nixSettingsModule;
  };
}
