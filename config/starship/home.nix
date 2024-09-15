{ lib, ... }:
{
  programs.starship = {
    enable = true;

    settings = (lib.importTOML ./config.toml);
  };
}
