{
  users ? { },
}:
{
  experimental-features = [
    "nix-command"
    "flakes"
  ];
  accept-flake-config = true;
  warn-dirty = false;
  trusted-users = builtins.attrNames users;
  trusted-public-keys = [
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "luke-channings.cachix.org-1:ETsZ3R5ue9QOwO4spg8aGJMwMU6k5tQIaHWnTakGHjo="
  ];

  substituters = [
    "https://devenv.cachix.org"
    "https://luke-channings.cachix.org"
  ];

  max-substitution-jobs = 128;
  http-connections = 0;
}
