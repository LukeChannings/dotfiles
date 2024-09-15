{ pkgs, ... }:
let
  inherit (pkgs._2lbx.lib) withInstallationMethod;
in
{
  config = {
    programs.chromium = {
      package =
        if pkgs.stdenv.isDarwin then
          (withInstallationMethod "copy" (pkgs.callPackage ./chromium-macos.nix { }))
        else
          pkgs.chromium;
      enable = true;
      extensions = [
        { "id" = "fmkadmapgofadopljbjfkapdkoienihi"; } # React Developer Tools
        { "id" = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      ];
    };
  };
}
