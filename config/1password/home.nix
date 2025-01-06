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
      programs._1password = {
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
        enableGitSigning = mkOption {
          type = types.bool;
          description = ''
            Enable 1Password git commit signing integration
          '';
          default = pkgs.stdenv.isDarwin;
        };
      };
    };

  config = {
    programs._1password-shell-plugins = {
      enable = true;
      plugins = config.programs._1password.shellPluginPackages;
    };

    programs.git = lib.mkIf config.programs._1password.enableGitSigning {
      iniContent = {
        gpg.format = "ssh";
        "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
  };
}
