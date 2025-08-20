{
  description = "Luke's dotfiles";

  inputs = {

    # System

    ## Package repositories

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";

    ## Secrets

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    ### Temporarily using https://github.com/1Password/shell-plugins/pull/503 until merged
    ### _1password-shell-plugins.url = "github:1Password/shell-plugins";
    _1password-shell-plugins.url = "github:LukeChannings/1password-shell-plugins/5ef7244";
    _1password-shell-plugins.inputs.nixpkgs.follows = "nixpkgs";

    ## Deployment
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs-latest";
    colmena.inputs.stable.follows = "nixpkgs";

    # Dev

    ## Nix

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    ## Not Nix...

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    helix.url = "helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";

    toolbox.url = "github:lukechannings/toolbox";
    toolbox.inputs.nixpkgs.follows = "nixpkgs";
    toolbox.inputs.flake-parts.follows = "flake-parts";
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
        inputs.treefmt-nix.flakeModule
        inputs.home-manager.flakeModules.home-manager
        ./modules/flakeModules/nix-darwin.nix
        ./modules/flakeModules/profiles.nix
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
          inputs',
          ...
        }:
        {
          packages = {
            inherit (inputs'.home-manager.packages) home-manager;

            ungoogled-chromium-macos = pkgs.callPackage ./packages/ungoogled-chromium-macos/package.nix { };
            mod_auth_openidc = pkgs.callPackage ./packages/mod_auth_openidc/package.nix { };
          };

          overlayAttrs = {
            inherit (config.packages) ungoogled-chromium-macos mod_auth_openidc;
          };
        };
    };
}
