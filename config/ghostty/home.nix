{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.brewCasks.ghostty else pkgs.ghostty;
    enableFishIntegration = true;
    installBatSyntax = false; # The brew package doesn't have share/bat/syntaxes/ghostty.sublime-syntax.
    settings = {
      macos-option-as-alt = "right";
      font-feature = "+calt, +liga, +dlig";
      font-size = 14;
      font-family = "RecMonoLinear Nerd Font Mono";
      macos-titlebar-proxy-icon = "hidden";
      window-padding-x = 6;
    };
  };
}
