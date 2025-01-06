{
  lib,
  osConfig,
  config,
  ...
}:
{
  config.programs.wezterm = {
    enable = true;

    extraConfig =
      builtins.replaceStrings
        [ "@multiplexingName@" ]
        [
          (lib.toLower (
            "${
              (if osConfig.networking.hostName != null then osConfig.networking.hostName else "wezterm")
            }_${config.home.username}"
          ))
        ]
        (builtins.readFile ./config.lua);
  };
}
