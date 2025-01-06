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
      default = true;
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

      programs.ssh.includes =
        let
          smallstepCfg = (
            pkgs.writeText "smallstep_config" ''
              Match exec "step ssh check-host %h"
                ProxyCommand step ssh proxycommand %r %h %p
                IdentityAgent "SSH_AUTH_SOCK"
                UserKnownHostsFile ${./smallstep_known_hosts}
            ''
          );
        in
        [
          "${smallstepCfg}"
        ];
    })

    (lib.mkIf (config.programs.ssh.domainCanon != null) (
      let
        domainCanonCfg = (
          pkgs.writeText "canonical_domain_config" ''
            Match all
              CanonicalizeHostname yes
              CanonicalizeMaxDots 0 # Don't canonicalise "ssh foo.bar", but do for "ssh foo"
              CanonicalDomains ${lib.concatStringsSep " " config.programs.ssh.domainCanon}
          ''
        );
      in
      {
        programs.ssh.includes = [ "${domainCanonCfg}" ];
      }
    ))

    (lib.mkIf config.programs.ssh.enable1PasswordAgent {
      programs.ssh.includes =
        let
          _1passwordCfg = (
            pkgs.writeText "1password_config" ''
              Match final all
                IdentityAgent "${
                  if pkgs.stdenv.isDarwin then
                    "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
                  else
                    "~/.1password/agent.sock"
                }"
            ''
          );
        in
        [ "${_1passwordCfg}" ];
    })
  ];
}
