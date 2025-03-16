{
  description = "Luke's dotfiles";

  inputs = {

    # System

    ## Package repositories

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # See https://lix.systems/add-to-config/#flake-based-configurations for the latest version
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-1.tar.gz";
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

    ## Deployment
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    colmena.inputs.stable.follows = "nixpkgs";

    # Dev

    ## Nix

    devenv-root.url = "file+file:///dev/null";
    devenv-root.flake = false;

    flake-parts.url = "github:hercules-ci/flake-parts";

    devenv.url = "github:cachix/devenv";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    ## Not Nix...

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    helix.url = "helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";

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
        ./modules
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
        helix = inputs.helix.overlays.default;
      };

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

            user.name = "luke";

            disabledModules = [
              "chromium"
              "wezterm"
              "vscode"
              "fonts"
            ];

            config.dotfiles.defaultPackages.enableMacUtilities = false;
          };
        };
    };
}
