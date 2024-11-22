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
])
++ [ pkgs.vscode-marketplace."1password".op-vscode ]
