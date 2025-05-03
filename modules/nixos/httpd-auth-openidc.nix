{ pkgs, ... }: {
  services.httpd.extraModules = [
    {
      name = "auth_openidc";
      path = "${pkgs.mod_auth_openidc}/modules/mod_auth_openidc.so";
    }
  ];
}
