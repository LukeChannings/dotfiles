{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.ssh;
in
{
  options.programs.ssh = with lib; {
    enableDefaultMacOSAgent = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Sets the SSH_AUTH_SOCK env variable from the launchctl environment.
      '';
    };

    enableSmallstep = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable step-cli and integrate with SSH.
      '';
    };

    enable1PasswordAgent = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable 1Password SSH agent.
      '';
    };

    domainCanon = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = [
        "lon.channings.me"
        "ind.channings.me"
      ];
      description = ''
        Transforms '<host>' to '<host>.lon.channings.me'.
        A host is valid if it has an A record.
      '';
    };
  };

  config = lib.mkMerge [
    {
      programs.ssh = {
        enable = lib.mkDefault true;

        # https://www.psc.edu/hpn-ssh-home/
        # Enable HPN-SSH from PSC
        # Patches SSH with optimisations for long network paths.
        package = lib.mkDefault pkgs.openssh_hpn;
      };
    }

    (lib.mkIf cfg.enableDefaultMacOSAgent {
      home.sessionVariables.SSH_AUTH_SOCK = "$(launchctl getenv SSH_AUTH_SOCK)";
    })

    (lib.mkIf (cfg.domainCanon != null) ({
      programs.ssh.matchBlocks.canonical = {
        match = "all";
        extraOptions = {
          CanonicalizeHostname = "yes";
          CanonicalizeMaxDots = "0"; # Don't canonicalise "ssh foo.bar", but do for "ssh foo"
          CanonicalDomains = "${lib.concatStringsSep " " cfg.domainCanon}";
        };
      };
    }))

    (lib.mkIf cfg.enableSmallstep {
      programs.ssh.matchBlocks.smallstep = lib.hm.dag.entryAfter [ "canonical" ] (
        let
          step = lib.getExe pkgs.step-cli;
        in
        {
          match = "final exec \"${step} ssh check-host %h\"";
          proxyCommand = "${step} ssh proxycommand --issuer=oidc %r %h %p";
          extraOptions = {
            IdentityAgent = "SSH_AUTH_SOCK";
          };
        }
      );
    })

    (lib.mkIf cfg.enable1PasswordAgent {
      programs.ssh.matchBlocks._1password = lib.hm.dag.entryAfter [ "smallstep" ] {
        match = "final all";
        extraOptions = {
          IdentityAgent =
            if pkgs.stdenv.isDarwin then
              "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
            else
              "~/.1password/agent.sock";
        };
      };
    })
  ];
}
