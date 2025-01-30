{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.programs.ssh = with lib; {
    enableDefaultMacOSAgent = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isDarwin;
      description = ''
        Sets the SSH_AUTH_SOCK env variable from the launchctl environment.
      '';
    };

    enableSmallstepCA = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isDarwin;
      description = ''
        Enable step-cli and integrate with SSH.
      '';
    };

    enable1PasswordAgent = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isDarwin;
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

    (lib.mkIf config.programs.ssh.enableDefaultMacOSAgent {
      home.sessionVariables.SSH_AUTH_SOCK = "$(launchctl getenv SSH_AUTH_SOCK)";
    })

    (lib.mkIf config.programs.ssh.enableSmallstepCA {
      home.packages = [ pkgs.step-cli ];

      home.file.".ssh/smallstep_known_hosts".source = ./smallstep_known_hosts;

      home.file.".ssh/smallstep_config.inc".text = ''
        Match exec "step ssh check-host %h"
          ProxyCommand step ssh proxycommand --issuer=oidc %r %h %p
          IdentityAgent "SSH_AUTH_SOCK"
          UserKnownHostsFile ~/.ssh/smallstep_known_hosts
      '';

      programs.ssh.includes = [ "~/.ssh/smallstep_config.inc" ];
    })

    (lib.mkIf (config.programs.ssh.domainCanon != null) (
      {
        home.file.".ssh/canonical_domain_config.inc".text = ''
          Match all
            CanonicalizeHostname yes
            CanonicalizeMaxDots 0 # Don't canonicalise "ssh foo.bar", but do for "ssh foo"
            CanonicalDomains ${lib.concatStringsSep " " config.programs.ssh.domainCanon}
        '';
        programs.ssh.includes = [ "~/.ssh/canonical_domain_config.inc" ];
      }
    ))

    (lib.mkIf config.programs.ssh.enable1PasswordAgent {
      home.file.".ssh/1password_config.inc".text = ''
        Match final all
          IdentityAgent "${
            if pkgs.stdenv.isDarwin then
              "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
            else
              "~/.1password/agent.sock"
          }"
      '';
      programs.ssh.includes = [ "~/.ssh/1password_config.inc" ];
    })
  ];
}
