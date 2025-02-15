{ user, config, lib, ... }:
let
  hmConfig = config.home-manager.users.${user.name};
in
{
  config = lib.mkIf hmConfig.programs.zsh.enable {
    programs.zsh = {
      enable = true;
      loginShellInit = ". /etc/zprofile\n";
    };
  };
}
