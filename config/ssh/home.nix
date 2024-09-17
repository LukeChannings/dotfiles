{
  config,
  ...
}:
{
  config.programs.ssh = {
    enable = true;

    forwardAgent = true;
    hashKnownHosts = true;
    addKeysToAgent = "yes";
  };
}
