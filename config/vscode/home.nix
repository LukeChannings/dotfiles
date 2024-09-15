{
  lib,
  pkgs,
  config,
  inputs,
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

    extensions =
      let
        extensions = inputs.vscode-extensions.extensions.${pkgs.system};
      in
      (with extensions.vscode-marketplace; [
        zhuangtongfa.material-theme
        mkhl.direnv
        editorconfig.editorconfig
        redhat.vscode-yaml
        redhat.vscode-xml
        streetsidesoftware.code-spell-checker
        eamodio.gitlens
        tamasfe.even-better-toml
        jnoortheen.nix-ide
      ])
      ++ [ extensions.vscode-marketplace."1password".op-vscode ];
  };

  config.home.packages = [
    (pkgs.writeShellScriptBin "code" ''
      ${config.programs.vscode.package}/Applications/VSCodium.app/Contents/MacOS/Electron $@
    '')
  ];
}
