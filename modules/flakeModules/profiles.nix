{
  lib,
  flake-parts-lib,
  moduleLocation,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mkOption
    types
    ;
in
{
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      darwinProfiles = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        apply = mapAttrs (
          k: v: {
            _class = "darwin";
            _file = "${builtins.toString moduleLocation}#darwinProfiles.${k}";
            imports = [ v ];
          }
        );
        description = ''
          Darwin profiles.
        '';
      };
      nixosProfiles = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        apply = mapAttrs (
          k: v: {
            _class = "nixos";
            _file = "${builtins.toString moduleLocation}#nixosProfiles.${k}";
            imports = [ v ];
          }
        );
        description = ''
          NixOS profiles
        '';
      };
      homeManagerProfiles = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        apply = mapAttrs (
          k: v: {
            _class = "homeManager";
            _file = "${builtins.toString moduleLocation}#homeManagerProfiles.${k}";
            imports = [ v ];
          }
        );
        description = ''
          Home Manager profiles.
        '';
      };
    };
  };
}
