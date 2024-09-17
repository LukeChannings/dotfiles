{
  pkgs,
  lib,
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
      ncdu

      # Networking
      dig
      curl
      jq

      # Other
      ripgrep
      chafa
      ;
  };

  allDefaultPackages = cliTools // (if pkgs.stdlib.isDarwin then macUtilities else { });
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
    home.packages = (
      with builtins; attrValues (removeAttrs allDefaultPackages config.dotfiles.disabledDefaultPackages)
    );
  };
}
