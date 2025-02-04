{
  pkgs ? import <nixpkgs> { },
}:
with pkgs;
mkShell {
  packages = [ nodejs_22 yarn ];
}
