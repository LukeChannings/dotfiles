{ ... }:
let
  substituters = [
    {
      url = "https://attic.svc.channings.me/nix";
      key = "nix:CLpxkxK7MCT/RRXSU2EpfiQVoCLreSR6QiJGzHtcyYQ=";
    }
    {
      url = "https://cache.nixos.org";
      key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    }
    {
      url = "https://nix-community.cachix.org";
      key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
    {
      url = "https://luke-channings.cachix.org";
      key = "luke-channings.cachix.org-1:ETsZ3R5ue9QOwO4spg8aGJMwMU6k5tQIaHWnTakGHjo=";
    }
    {
      url = "https://devenv.cachix.org";
      key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    }
    {
      url = "https://nixos-raspberrypi.cachix.org";
      key = "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=";
    }
  ];
  nixSettingsModule = { nixpkgs, nixpkgs-latest, ... }: {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # It's tempting to enable this, but it's a massive security hole
      accept-flake-config = false;

      warn-dirty = false;

      trusted-users = [
        "luke@idm.svc.channings.me"
        "luke@channings.me"
        "luke"
      ];

      substituters = map (_: _.url) substituters;
      trusted-substituters = map (_: _.url) substituters;
      trusted-public-keys = map (_: _.key) substituters;

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
