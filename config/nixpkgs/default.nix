{ self, ... }:
{
  flake =
    let
      nixpkgsSettingsModule = (
        { config, nixpkgs-latest, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            self.overlays.default
            (final: prev: {
              latest = import nixpkgs-latest { inherit (final) system config; };
            })
          ];
        }
      );
    in
    {
      homeModules.nixpkgs = nixpkgsSettingsModule;
      nixosModules.nixpkgs = nixpkgsSettingsModule;
      darwinModules.nixpkgs = nixpkgsSettingsModule;
    };
}
