{ pkgs, ... }:
{
  config = {
    programs.chromium = {
      enable = true;
      package = pkgs.${if pkgs.stdenv.isDarwin then "ungoogled-chromium-macos" else "chromium"};
      extensions = [
        { "id" = "fmkadmapgofadopljbjfkapdkoienihi"; } # React Developer Tools
        { "id" = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      ];
    };
  };
}
