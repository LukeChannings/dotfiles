{
  osConfig,
  lib,
  ...
}:
let
  useGlobalPkgs = if osConfig == null then false else osConfig.home-manager.useGlobalPkgs;
in
{
  config = lib.mkIf (!useGlobalPkgs) {
    nixpkgs.config = import ./config.nix;
  };
}
