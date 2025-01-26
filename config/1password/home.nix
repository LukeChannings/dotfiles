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
    with types;
    {
      programs._1password-cli = {
        enable = mkOption {
          type = bool;
          description = ''
            Enables 1Password shell integration
          '';
          default = true;
        };
        shellPluginPackages = mkOption {
          type = listOf package;
          description = ''
            Packages to be installed with 1Password shell integration
          '';
          default = [ pkgs.gh ];
        };
        sshAgent = mkOption {
          description = ''
            Configuration for the 1Password SSH agent.
            See: https://developer.1password.com/docs/ssh/agent/config
          '';
          type = nullOr (submodule {
            options.keys = mkOption {
              type = listOf (submodule {
                options = {
                  item = mkOption {
                    type = nullOr str;
                    description = "The item name or ID";
                    default = null;
                  };

                  vault = mkOption {
                    type = nullOr str;
                    description = "The vault name or ID";
                    default = null;
                  };

                  account = mkOption {
                    type = nullOr str;
                    description = "The account name sign-in address or ID";
                    default = null;
                  };
                };
              });
              default = [ ];
            };
          });
          default = null;
        };
      };
    };

  config = {
    programs._1password-shell-plugins = {
      enable = true;
      plugins = config.programs._1password-cli.shellPluginPackages;
    };

    xdg.configFile."1Password/ssh/agent.toml".source =
      lib.mkIf (config.programs._1password-cli.sshAgent != null)
        (
          let
            tomlFormatter = pkgs.formats.toml { };
          in
          tomlFormatter.generate "agent.toml" {
            "ssh-keys" = builtins.map (lib.filterAttrs (
              _: v: v != null
            )) config.programs._1password-cli.sshAgent.keys;
          }
        );
  };
}
