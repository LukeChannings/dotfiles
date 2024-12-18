{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (builtins) attrValues;

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
      ncdu_1

      # Networking
      dig
      curl
      jq

      # Other
      ripgrep
      chafa
      ;
  };

  allDefaultPackages = cliTools // (if pkgs.stdenv.isDarwin then macUtilities else { });
in
{
  options.dotfiles = {
    disabledDefaultPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        A list of default apps that you don't want to install
      '';
      default = [ ];
    };
  };

  config = {
    home.packages = attrValues (removeAttrs allDefaultPackages config.dotfiles.disabledDefaultPackages);
  };
}
