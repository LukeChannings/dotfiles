{ pkgs, lib, ... }: {
  nix.package = lib.mkDefault pkgs.lix;
  programs.nix-index-database.comma.enable = true;
}
