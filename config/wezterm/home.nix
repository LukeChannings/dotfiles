{
  lib,
  osConfig,
  config,
  ...
}:
{
  config.programs.wezterm = {
    enable = true;

    extraConfig = builtins.replaceStrings [ "@multiplexingName@" ] [
      (lib.toLower ("${osConfig.networking.hostName}_${config.home.username}"))
    ] (builtins.readFile ./config.lua);
  };
}
