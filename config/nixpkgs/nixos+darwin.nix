# These settings are inherited by home-manager when `useGlobalPkgs` is enabled.
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;
}
