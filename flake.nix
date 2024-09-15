{
  description = "Luke's toolbox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    devenv.url = "github:cachix/devenv";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    toolbox.url = "github:lukechannings/toolbox";
    # toolbox.url = "path:/Users/luke/Developer/Scratch/toolbox";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      # for local testing via `nix flake check` while developing 
      #url = "path:../";
      url = "github:LukeChannings/brew-nix";
      # url = "path:/Users/luke/Developer/Scratch/brew-nix";
      inputs.brew-api.follows = "brew-api";
      inputs.nix-darwin.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    _1password-shell-plugins.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.modules
        inputs.devenv.flakeModule
        inputs.treefmt-nix.flakeModule
        ./devenv.nix
        ./config
        ./templates
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-darwin"

        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        {
          packages = {
            inherit (inputs.home-manager.packages.${system}) home-manager;
          };

          legacyPackages.homeConfigurations.luke = self.lib.mkHomeManagerConfiguration {
            inherit pkgs;
            disabledModules = [
              "default-apps"
              "chromium"
              "1password"
              "wezterm"
              "vscode"
              "fonts"
            ];
            config.home = {
              username = "luke";
              homeDirectory = "/home/luke";
            };
          };
        };
    };

  nixConfig = {
    extra-substituters = [ "https://luke-channings.cachix.org" ];
    extra-trusted-public-keys = [
      "luke-channings.cachix.org-1:ETsZ3R5ue9QOwO4spg8aGJMwMU6k5tQIaHWnTakGHjo="
    ];
  };
}
