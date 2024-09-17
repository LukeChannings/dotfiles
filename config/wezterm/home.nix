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
      (lib.toLower ("${osConfig.networking.hostName or "wezterm"}_${config.home.username}"))
    ] (builtins.readFile ./config.lua);
  };
}
