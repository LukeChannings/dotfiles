{ inputs, ... }:
{
  imports = [
    inputs.brew-nix.darwinModules.default
  ];

  brew-nix.enable = true;

  nixpkgs.overlays = [ (import ./overlay.nix) ];
}
