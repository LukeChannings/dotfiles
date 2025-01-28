{ pkgs }:
(with pkgs.vscode-marketplace; [
  zhuangtongfa.material-theme
  mkhl.direnv
  editorconfig.editorconfig
  redhat.vscode-yaml
  redhat.vscode-xml
  streetsidesoftware.code-spell-checker
  eamodio.gitlens
  tamasfe.even-better-toml
  github.codespaces
  github.copilot
  jnoortheen.nix-ide
])
++ [ pkgs.vscode-marketplace."1password".op-vscode ]
