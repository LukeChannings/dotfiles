{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins;
let
  authorityModule = types.submodule {
    options = {
      caUrl = mkOption {
        type = types.str;
      };
      redirectUrl = mkOption {
        type = types.str;
        default = "";
      };
      fingerprint = mkOption {
        type = types.str;
      };
      certFile = mkOption {
        type = types.path;
      };
      defaults = mkOption {
        type = types.attrs;
        default = { };
      };
    };
  };
  cfg = config.programs.smallstep;
in
{
  options.programs.smallstep = {
    enable = mkEnableOption "Enable step-cli";

    defaultAuthority = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    authorities = mkOption {
      type = types.attrsOf authorityModule;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.step-cli ];

    home.file = mkIf (cfg.authorities != { }) (
      mkMerge (
        (map (
          { name, value }:
          {
            ".step/authorities/${name}/config/defaults.json".text = (
              toJSON {
                "ca-url" = value.caUrl;
                "redirect-url" = value.redirectUrl;
                "fingerprint" = value.fingerprint;
                "root" = value.certFile;
              }
            );
            ".step/authorities/${name}/certs/root_ca".source = value.certFile;
            ".step/profiles/${name}/config/defaults.json".text = (toJSON value.defaults);
          }
        ) (attrsToList cfg.authorities))
        ++ [
          {
            ".step/contexts.json".text = (
              toJSON (
                mapAttrs (name: value: {
                  profile = name;
                  authority = name;
                }) cfg.authorities
              )
            );
            ".step/default-context.json".text = mkIf (cfg.defaultAuthority != null) (
              toJSON ({
                context = cfg.defaultAuthority;
              })
            );
          }
        ]
      )
    );

    home.activation = mkIf (cfg.defaultAuthority != null) {
      smallstep = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -f "$HOME/.step/current-context.json" ]; then
          run cp -s $VERBOSE_ARG "$HOME/.step/default-context.json" "$HOME/.step/current-context.json"
        fi
      '';
    };
  };
}
