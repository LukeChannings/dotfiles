{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dotfiles;
in
with lib;
{
  options.dotfiles.loginItems = mkOption {
    type = types.attrsOf (types.either types.package types.str);
    default = { };
  };

  config = {
    launchd.agents = lib.mkIf (cfg.loginItems != { }) (
      builtins.mapAttrs (name: pkg: {
        enable = true;
        config.Program = "${pkg}/Contents/MacOS/${name}";
        config.RunAtLoad = true;
        config.KeepAlive = true;
      }) cfg.loginItems
    );
  };
}
