{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.helix.overlays.default
  ];
}
