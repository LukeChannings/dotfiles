{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  options =
    let
      inherit (lib) types mkOption;
    in
    {
      programs._1password-cli = {
        enable = mkOption {
          type = types.bool;
          description = ''
            Enables 1Password shell integration
          '';
          default = true;
        };
        shellPluginPackages = mkOption {
          type = (with types; listOf package);
          description = ''
            Packages to be installed with 1Password shell integration
          '';
          default = [ pkgs.gh ];
        };
      };
    };

  config = {
    programs._1password-shell-plugins = {
      enable = true;
      plugins = config.programs._1password-cli.shellPluginPackages;
    };
  };
}
