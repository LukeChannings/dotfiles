{
  pkgs,
  ...
}:
{
  config = {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        lsd
        tree
        ripgrep
        chafa
        dig
        jq
        curl
        ncdu
        ;
    };
  };
}
