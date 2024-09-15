{ pkgs, ... }:
{
  programs.bat = {
    enable = true;

    config = {
      theme = "OneHalfDark";
      style = "plain";
    };

    extraPackages = builtins.attrValues { inherit (pkgs.bat-extras) batman batgrep batwatch; };
  };
}
