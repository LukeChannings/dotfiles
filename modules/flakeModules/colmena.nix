{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
  inherit (inputs.colmena.lib) makeHive;
  inherit (inputs.colmena.nixosModules) metaOptions;
in
{
  options = {
    flake.colmena = mkOption {
      type = types.submodule {
        freeformType = types.lazyAttrsOf types.raw;

        options.meta = mkOption {
          type = types.submodule (metaOptions {
            inherit lib;
          });
          default = { };
        };
      };

      default = { };
    };
  };

  config = {
    flake.colmenaHive = makeHive config.flake.colmena;
  };
}
