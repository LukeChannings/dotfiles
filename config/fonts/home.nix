{
  pkgs,
  ...
}:
{
  config = {
    fonts.fontconfig = {
      enable = true;

      defaultFonts.monospace = [
        "RecMonoLinear Nerd Font Mono"
        "Menlo"
      ];
    };

    home.packages = with pkgs.nerd-fonts; [
      recursive-mono
      hasklug
      victor-mono
      fira-code
      iosevka-term
    ];
  };
}
