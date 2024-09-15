{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs._2lbx.lib) installByCopying;
  inherit (builtins) attrValues;
in
{
  config = {
    home.packages = lib.mkIf pkgs.stdenv.isDarwin (
      attrValues ({
        inherit (pkgs.brewCasks)
          apparency
          raycast
          maccy
          swish
          contexts
          hot
          suspicious-package
          monitorcontrol
          the-unarchiver
          plexamp
          blender
          utm
          # logitech-options
          ;
      })
      ++ (installByCopying (with pkgs.brewCasks; [ arc ]))
    );
  };
}
