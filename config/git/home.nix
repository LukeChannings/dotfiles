{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.programs.git = with types; {
    signingInclude = mkOption {
      type = nullOr (
        attrsOf (submodule {
          options = {
            enable = lib.mkEnableOption "Enable code signing for GitHub repos";

            conditions = mkOption {
              type = nullOr (listOf str);
              default = null;
            };

            signingKey = mkOption {
              type = str;
              description = "The key to use for signing commits";
            };

            signByDefault = mkOption {
              type = bool;
              default = true;
              description = "Whether commits and tags should be signed by default.";
            };

            gpgPath = mkOption {
              type = str;
              default = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
              description = "Path to the commit signing binary";
            };

            allowedSigners = mkOption {
              type = listOf str;
              default = [ ];
            };
          };
        })
      );
      default = null;
    };
  };

  # Check per-repo config with `git config -l`
  config = lib.mkMerge [
    {
      programs.git = {
        enable = true;

        extraConfig = {
          pull.rebase = true;
          rebase.autostash = true;
          push.autosetupremote = true;
          init.defaultBranch = "main";
        };

        lfs.enable = true;
        difftastic.enable = true;
      };
    }
    (lib.mkIf (config.programs.git.signingInclude != null) {

      # Each signing configuration gets its own file in ~/.config/git.
      xdg.configFile = concatMapAttrs (name: cfg: {
        "git/${name}_signing.inc".text = generators.toGitINI {
          user.signingkey = cfg.signingKey;
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = pkgs.writeText "${name}_allowed_signers" (
            concatLines (
              [ "${config.programs.git.userEmail} namespaces=\"git\" ${cfg.signingKey}" ] ++ cfg.allowedSigners
            )
          );
          "gpg \"ssh\"".program = cfg.gpgPath;
          commit.gpgsign = cfg.signByDefault;
        };
      }) config.programs.git.signingInclude;

      programs.git.includes = flatten (
        mapAttrsToList (
          name: cfg:
          let
            path = "${name}_signing.inc";
          in
          (
            if cfg.conditions == null then
              { inherit path; }
            else
              builtins.map (condition: {
                inherit condition;
                inherit path;
              }) cfg.conditions
          )
        ) config.programs.git.signingInclude
      );
    })
  ];
}
