{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) stdenv darwin;
in
{
  config = {
    programs.nushell = {
      enable = true;

      envFile.text = (builtins.readFile ./env.nu);
      configFile.text = (builtins.readFile ./config.nu);
      loginFile.text = (builtins.readFile ./login.nu);
    };

    home.packages =
      let
        fixupForDarwin =
          drv:
          drv.overrideAttrs (oldAttrs: {
            buildInputs =
              oldAttrs.buildInputs
              ++ lib.optionals stdenv.isDarwin [
                darwin.apple_sdk.frameworks.IOKit
                darwin.apple_sdk.frameworks.Security
                darwin.apple_sdk.frameworks.CoreServices
              ];
          });
      in
      (map fixupForDarwin (
        with pkgs.nushellPlugins;
        [
          formats
          polars
          query
#          net
#          units
        ]
      ));
  };
}
