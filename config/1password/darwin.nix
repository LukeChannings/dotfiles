{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    programs._1password-gui = {
      enable = lib.mkEnableOption "1Password GUI";
    };
  };

  config = lib.mkIf config.programs._1password-gui.enable {
    environment.systemPackages = [ pkgs._1password-gui ];

    home-manager.sharedModules = [
      (
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          options.programs._1password = {
            enable = lib.mkEnableOption "1Password CLI";
          };

          config = lib.mkIf config.programs._1password.enable { home.packages = [ pkgs._1password ]; };
        }
      )
    ];
  };
}
