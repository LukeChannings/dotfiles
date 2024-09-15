{
  pkgs,
  ...
}:
{
  config = {
    programs.nushell = {
      enable = true;

      envFile.text = (builtins.readFile ./env.nu);
      configFile.text = (builtins.readFile ./config.nu);
      loginFile.text = (builtins.readFile ./login.nu);
    };

    home.packages = [ pkgs.nushellPlugins.formats ];
  };
}
