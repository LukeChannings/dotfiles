{
  description = "Configuration for Luke's Work MacBook Pro";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    dotfiles.url = "github:lukechannings/dotfiles";
    dotfiles.inputs.devenv-root.follows = "devenv-root";
  };

  outputs =
    inputs@{ dotfiles, self, ... }:
    let
      inputs' = dotfiles.inputs // inputs;
    in
    inputs'.flake-parts.lib.mkFlake { inputs = inputs'; } {
      imports = [
        ./devenv.nix
        ./configuration.nix
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-darwin"

        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { system, ... }:
        let
          pkgs = inputs'.nixpkgs.legacyPackages.${system};
        in
        {
          _module.args.pkgs = pkgs;

          packages =
            let
              inherit (inputs.dotfiles.inputs.nix-darwin.packages.${system}) darwin-rebuild;
            in
            {
              inherit darwin-rebuild;

              activate = pkgs.writeScriptBin "activate" ''
                #!${pkgs.bash}/bin/bash
                sudo rm -rf ~/.nix-defexpr
                sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
                export NIX_CONFIG="experimental-features = nix-command flakes"
                ${darwin-rebuild}/bin/darwin-rebuild switch --flake ${self}#default
              '';
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
