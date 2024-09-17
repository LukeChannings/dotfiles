{
  description = "Configuration for Luke's CAIS MacBook Pro";

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
                ${darwin-rebuild}/bin/darwin-rebuild switch --flake ${self}#default
              '';
            };
        };
    };
}
