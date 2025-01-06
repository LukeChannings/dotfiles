{
  description = "Luke's toolbox";

  inputs = {

    # System

    ## Package repositories

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    brew-api.url = "github:BatteredBunny/brew-api";
    brew-api.flake = false;
    brew-nix.url = "github:LukeChannings/brew-nix";
    brew-nix.inputs.nixpkgs.follows = "nixpkgs";
    brew-nix.inputs.nix-darwin.follows = "nixpkgs";
    brew-nix.inputs.brew-api.follows = "brew-api";

    ## Supporting configuration modules
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ## Secrets

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    ### Temporarily using https://github.com/1Password/shell-plugins/pull/503 until merged
    ### _1password-shell-plugins.url = "github:1Password/shell-plugins";
    _1password-shell-plugins.url = "github:LukeChannings/1password-shell-plugins/5ef7244";
    _1password-shell-plugins.inputs.nixpkgs.follows = "nixpkgs";

    # Dev

    ## Nix

    devenv-root.url = "file+file:///dev/null";
    devenv-root.flake = false;

    flake-parts.url = "github:hercules-ci/flake-parts";

    devenv.url = "github:cachix/devenv";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    ## Not Nix...

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

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
        lix = inputs.lix-module.overlays.default;
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
              inputs.lix-module.overlays.default
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
