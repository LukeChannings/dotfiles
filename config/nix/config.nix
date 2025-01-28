{
  users ? { },
}:
with builtins;
let substituters = import ./substituters.nix; 
in
{
  experimental-features = [
    "nix-command"
    "flakes"
  ];

  accept-flake-config = false;

  warn-dirty = false;
  trusted-users = attrNames users;

  substituters = map (k: "https://${head (split "-1:" k)}") substituters;
  trusted-public-keys = substituters;

  max-substitution-jobs = 128;
  http-connections = 0;
}
