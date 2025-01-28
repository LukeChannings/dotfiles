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

  cfg = config.dotfiles.defaultPackages;
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
            (if cfg.enableMacUtilities then macUtilities else { })
            // (if cfg.enableCliTools then cliTools else { });
        };
      };
    };
    default = {};
  };

  config = {
    home.packages = attrValues (removeAttrs cfg.packages cfg.disabledPackageNames);
  };
}
