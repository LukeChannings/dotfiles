{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dotfiles.attic = {
    watch-daemon = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Enable the attic watch-store daemon";
          cache = lib.mkOption {
            type = lib.types.str;
            description = "The cache to push to";
          };
        };
      };
    };
  };

  config = {
    home.packages = [
      pkgs.attic-client
    ];

    launchd.agents = lib.mkIf config.dotfiles.attic.watch-daemon.enable {
      attic =
        let
          inherit (config.home) homeDirectory;
        in
        {
          enable = true;
          config.ProgramArguments = [
            (lib.getExe pkgs.attic-client)
            "watch-store"
            config.dotfiles.attic.watch-daemon.cache
          ];
          config.RunAtLoad = true;
          config.KeepAlive = true;
          config.SoftResourceLimits.NumberOfFiles = 1048576;
          config.HardResourceLimits.NumberOfFiles = 1048576;
          config.LowPriorityIO = true;
          config.ProcessType = "Background";
          config.StandardErrorPath = "${homeDirectory}/Library/Logs/attic-watch-daemon.log";
          config.StandardOutPath = "${homeDirectory}/Library/Logs/attic-watch-daemon.log";
          config.EnvironmentVariables = {
            HOME = homeDirectory;
            XDG_CONFIG_HOME = "${homeDirectory}/.config";
          };
        };
    };
  };
}
