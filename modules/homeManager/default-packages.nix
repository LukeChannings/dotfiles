{
  pkgs,
  lib,
  config,
  ...
}:
let
  macUtilities = {
    inherit (pkgs.brewCasks)
      apparency
      suspicious-package
      the-unarchiver

      raycast
      maccy
      swish
      contexts

      hot
      monitorcontrol
      ghostty
      ;
  };

  cliTools = {
    inherit (pkgs)
      # File Management
      tree
      ncdu

      # Networking
      dig
      curl
      jq

      # Other
      ripgrep
      chafa

      # Nix
      nix-top
      ;
  };

  cfg = config.dotfiles;
in
with lib;
{
  options.dotfiles.defaultPackages = mkOption {
    type = types.submodule {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable the default package set";
        };

        enableMacUtilities = mkOption {
          type = types.bool;
          default = pkgs.stdenv.isDarwin;
        };

        enableCliTools = mkOption {
          type = types.bool;
          default = true;
        };

        disabledPackageNames = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };

        packages = mkOption {
          type = types.attrsOf types.package;
          internal = true;
          default =
            (if cfg.defaultPackages.enableMacUtilities then macUtilities else { })
            // (if cfg.defaultPackages.enableCliTools then cliTools else { });
        };
      };
    };
    default = { };
  };

  options.dotfiles.loginItems = mkOption {
    type = types.attrsOf (types.either types.package types.str);
    default = { };
  };

  config = {
    home.packages = attrValues (
      removeAttrs cfg.defaultPackages.packages cfg.defaultPackages.disabledPackageNames
    );

    launchd.agents = lib.mkIf (cfg.loginItems != { }) (
      builtins.mapAttrs (name: pkg: {
        enable = true;
        config.Program = "${pkg}/Contents/MacOS/${name}";
        config.ProgramArguments = [ "${pkg}/Contents/MacOS/${name}" ];
        config.RunAtLoad = true;
        config.KeepAlive = true;
      }) cfg.loginItems
    );
  };
}
