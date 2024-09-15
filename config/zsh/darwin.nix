{ config, lib, ... }:
let
  defaultUser = builtins.head config.users.knownUsers;
  hmConfig = config.home-manager.users.${defaultUser};
in
{
  config = lib.mkIf hmConfig.programs.zsh.enable {
    programs.zsh = {
      enable = true;
      loginShellInit = ". /etc/zprofile\n";
    };
  };
}
