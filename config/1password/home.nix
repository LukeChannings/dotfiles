{ inputs, pkgs, ... }:
{
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh ];
  };
}
