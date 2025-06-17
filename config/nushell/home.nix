{
  pkgs,
  ...
}:
{
  config = {
    programs.nushell = {
      enable = true;
      package = pkgs.latest.nushell;

      envFile.text = (builtins.readFile ./env.nu);
      configFile.text = (builtins.readFile ./config.nu);
      loginFile.text = (builtins.readFile ./login.nu);
    };

    home.packages = with pkgs.latest.nushellPlugins; [
      formats
      polars
      query
    ];
  };
}
