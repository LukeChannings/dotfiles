{
  lib,
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = (lib.importTOML ./config.toml);

    themes = {
      onedark = {
        inherits = "onedark";

        "ui.background" = "#ff0000";
      };
    };

    languages = {
      language-server = {
        nil = {
          command = lib.getExe pkgs.nil;
          config = {
            nix = {
              maxMemoryMB = 2560;
              flake = {
                autoArchive = false;
                autoEvalInputs = true;
              };
            };
          };
        };
        lua-language-server = {
          command = lib.getExe pkgs.lua-language-server;
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
        }
        {
          name = "lua";
          auto-format = true;
          formatter.command = lib.getExe pkgs.stylua;
        }
      ];
    };
  };
}
