{
  description = "Luke's dotfiles";

  inputs = {

    # System

    ## Package repositories

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # # See https://lix.systems/add-to-config/#flake-based-configurations for the latest version
    # lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
    # lix-module.inputs.nixpkgs.follows = "nixpkgs";

    # https://wiki.lix.systems/books/lix-contributors/page/running-lix-main
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.lix.follows = "lix";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-stable";

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

    ## Secrets

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-stable";

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
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    ## Not Nix...

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

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
        flake-parts.flakeModules.easyOverlay
        inputs.devenv.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.home-manager.flakeModules.home-manager
        ./modules/flakeModules/nix-darwin.nix
        ./modules/flakeModules/profiles.nix
        ./devenv.nix
        ./config
        ./templates
        ./modules

        ./profiles/base.nix
        ./profiles/server.nix
        ./profiles/container.nix
        ./profiles/personal-mac.nix
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-darwin"

        "x86_64-linux"
        "aarch64-linux"
      ];

      flake.vscode.systemExtensions =
        (nixpkgs.lib.importJSON ./.devcontainer.json).customizations.vscode.extensions;

      perSystem =
        {
          pkgs,
          lib,
          system,
          config,
          ...
        }:
        {
          packages = {
            inherit (inputs.home-manager.packages.${system}) home-manager;
            ungoogled-chromium-macos = pkgs.callPackage ./packages/ungoogled-chromium-macos/package.nix { };
            kanidm-tools = pkgs.callPackage ./packages/kanidm-tools/package.nix { };
            mod_auth_openidc = pkgs.callPackage ./packages/mod_auth_openidc/package.nix { };
          };

          overlayAttrs = {
            inherit (config.packages) ungoogled-chromium-macos kanidm-tools mod_auth_openidc;
          };
        };
    };
}
