{ extensions }:
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
++ [ extensions.vscode-marketplace."1password".op-vscode ]
