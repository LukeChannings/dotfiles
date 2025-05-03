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
      darwinConfigurations = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = { };
        description = ''
          Instantiated darwin configurations.

          `darwinConfigurations` is for specific installations. If you want to expose
          reusable configurations, add them to `darwinModules` in the form of modules, so
          that you can reference them in this or another flake's `darwinConfigurations`.
        '';
      };
      darwinModules = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        apply = mapAttrs (
          k: v: {
            _class = "darwin";
            _file = "${builtins.toString moduleLocation}#darwinModules.${k}";
            imports = [ v ];
          }
        );
        description = ''
          darwin modules.

          You may use this for reusable pieces of configuration, service modules, etc.
        '';
      };
    };
  };
}
