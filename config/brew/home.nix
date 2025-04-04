{
  inputs,
  osConfig,
  lib,
  ...
}:
let
  useGlobalPkgs = if osConfig == null then false else osConfig.home-manager.useGlobalPkgs;
in
{
  config = lib.mkIf (!useGlobalPkgs) {
    nixpkgs = {
      overlays = [
        inputs.brew-nix.overlays.default
        (import ./overlay.nix)
      ];
    };
  };
}
