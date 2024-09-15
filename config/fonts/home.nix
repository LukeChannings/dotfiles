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

    home.packages = [
      (pkgs.nerdfonts.override {
        fonts = [
          "Recursive"
          "Hasklig"
          "VictorMono"
          "FiraCode"
          "IosevkaTerm"
        ];
      })
    ];
  };
}
