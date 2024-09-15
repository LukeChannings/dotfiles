{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    programs.ssh.enable1PasswordAgent = lib.mkOption {
      description = "Enable 1Password agent";
      type = lib.types.bool;
      default = false;
    };
  };

  config.programs.ssh = {
    enable = true;

    forwardAgent = true;
    hashKnownHosts = true;
    addKeysToAgent = "yes";

    extraConfig = lib.mkIf (
      pkgs.stdenv.isDarwin && config.programs.ssh.enable1PasswordAgent
    ) "IdentityAgent \"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
  };
}
