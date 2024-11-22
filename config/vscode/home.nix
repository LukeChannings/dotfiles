{
  lib,
  pkgs,
  config,
  ...
}:
{
  config.programs.vscode = {
    enable = true;

    package = pkgs.vscodium.overrideAttrs (_final: _prev: { dontPatchShebangs = true; });

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    userSettings = (lib.importJSON ./settings.json) // {
      nix = {
        enableLanguageServer = true;
        serverPath = lib.getExe pkgs.nil;
        serverSettings.nil.formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
      };
    };
    keybindings = (lib.importJSON ./keybindings.json);

    extensions = import ./extensions.nix { inherit pkgs; };
  };

  config.home.packages = [
    (pkgs.writeShellScriptBin "code" ''
      ${config.programs.vscode.package}/Applications/VSCodium.app/Contents/MacOS/Electron $@
    '')
  ];
}
