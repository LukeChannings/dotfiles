{
  description = "Luke's dev environment";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nil.url = "github:oxalica/nil";
    toolbox.url = "github:lukechannings/toolbox";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
        inputs.treefmt-nix.flakeModule

        ./devenv.nix
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-darwin"

        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { system, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.vscode-extensions.overlays.default
              inputs.lix-module.overlays.default
            ];
            config = { };
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
