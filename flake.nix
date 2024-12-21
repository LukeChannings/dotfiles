{
  description = "Luke's toolbox";

  inputs = {
    devenv-root.url = "file+file:///dev/null";
    devenv-root.flake = false;

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    brew-api.url = "github:BatteredBunny/brew-api";
    brew-api.flake = false;

    brew-nix.url = "github:LukeChannings/brew-nix";
    brew-nix.inputs.nixpkgs.follows = "nixpkgs";
    brew-nix.inputs.nix-darwin.follows = "darwin";
    brew-nix.inputs.brew-api.follows = "brew-api";

    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    _1password-shell-plugins.inputs.nixpkgs.follows = "nixpkgs";

    toolbox.url = "github:lukechannings/toolbox";
    toolbox.inputs.nixpkgs.follows = "nixpkgs";
    toolbox.inputs.flake-parts.follows = "flake-parts";
    toolbox.inputs.devenv.follows = "devenv";
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nixpkgs,
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

      flake.vscode.systemExtensions =
        (nixpkgs.lib.importJSON ./.devcontainer.json).customizations.vscode.extensions;

      flake.overlays = {
        vscode-extensions = inputs.vscode-extensions.overlays.default;
      };

      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.vscode-extensions.overlays.default
            ];
            config = { };
          };

          packages = {
            inherit (inputs.home-manager.packages.${system}) home-manager;
          };

          legacyPackages.homeConfigurations.luke = self.lib.mkHomeManagerConfiguration {
            inherit pkgs;
            disabledModules = [
              "default-packages"
              "chromium"
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
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://luke-channings.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "luke-channings.cachix.org-1:ETsZ3R5ue9QOwO4spg8aGJMwMU6k5tQIaHWnTakGHjo="
    ];
  };
}
