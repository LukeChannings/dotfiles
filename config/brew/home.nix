{ inputs, ... }:
{
  nixpkgs = {
    overlays = [
      inputs.brew-nix.overlays.default
      (import ./overlay.nix)
    ];
  };
}
