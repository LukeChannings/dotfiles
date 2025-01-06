{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.lix;
    channel.enable = false;
    settings = (import ./config.nix { users = config.users.users; });
  };
}
