{
  inputs = {
    devenv-root.url = "file+file:///dev/null";
    devenv-root.flake = false;

    # nix registry add flake:dotfiles github:lukechannings/dotfiles
    dotfiles.url = "dotfiles";
    dotfiles.inputs.devenv-root.follows = "devenv-root";
  };

  outputs =
    flakeInputs@{
      dotfiles,
      self,
      ...
    }:
    let
      # I want to use the inputs from dotfiles in this flake
      # to avoid re-declaring those inputs and maintaining the
      # same versions.
      inputs = dotfiles.inputs // flakeInputs;

      inherit (inputs)
        nixpkgs
        treefmt-nix
        devenv
        ;
    in
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
        # I need to update `self.inputs` to be our merged inputs
        # otherwise `perSystem's inputs'` will be sourced from `flakeInputs` only.
        self = self // {
          inherit inputs;
        };
      }
      {
        imports = [
          treefmt-nix.flakeModule
          devenv.flakeModule

          ./devenv.nix
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
            system,
            ...
          }:
          {
            _module.args.pkgs = import nixpkgs {
              inherit system;
              overlays = [ dotfiles.overlays.vscode-extensions ];
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
